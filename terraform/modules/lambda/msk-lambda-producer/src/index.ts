import { Handler } from 'aws-lambda'
import { Kafka, Producer } from 'kafkajs'
import { generateAuthToken } from 'aws-msk-iam-sasl-signer-js'
import dayjs from 'dayjs'
import localizedFormat from 'dayjs/plugin/localizedFormat'

dayjs.extend(localizedFormat)
dayjs.locale('en')

const authToken = async () => {
  const response = await generateAuthToken({ region: process.env.AMAZON_REGION || 'us-east-1' })
  return {
    value: response.token,
  }
}

const kafka = new Kafka({
  clientId: 'msk-lambda-producer',
  brokers: process.env.MSK_BOOTSTRAP_BROKERS?.split(',') || [],
  ssl: true,
  sasl: {
    mechanism: 'oauthbearer',
    oauthBearerProvider: () => authToken(),
  },
})

const producer: Producer = kafka.producer()

const createTopicIfNotExists = async (topicName: string) => {
  const admin = kafka.admin()
  try {
    await admin.connect()
    const topics = await admin.listTopics()
    if (!topics.includes(topicName)) {
      await admin.createTopics({
        waitForLeaders: false,
        topics: [{ topic: topicName }],
      })
      console.log(`Topic ${topicName} created successfully`)
    }
  } catch (error) {
    console.error(`Error creating topic ${topicName}:`, error)
    throw error
  } finally {
    await admin.disconnect()
  }
}


export const handler: Handler = async (event) => {
  try {
    if (!process.env.TOPIC_NAME) {
      throw new Error('TOPIC_NAME is not set')
    }

    await createTopicIfNotExists(process.env.TOPIC_NAME || '')
    await producer.connect()

    const message = {
      timestamp: dayjs().format('LLLL'),
      data: event,
    }

    const metadata = await producer.send({
      topic: process.env.TOPIC_NAME || '',
      messages: [{ value: JSON.stringify(message) }],
    })

    await producer.disconnect()

    return {
      statusCode: 200,
      body: JSON.stringify({
        metadata,
        sentData: message,
      }),
    }
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Error in handler execution' }),
    }
  }
}
