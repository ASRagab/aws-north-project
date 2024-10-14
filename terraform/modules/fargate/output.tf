output "service_repository_urls" {
  value = [for service in module.services : service.core_services_repository_url]
}
