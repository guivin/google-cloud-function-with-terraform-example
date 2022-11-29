resource "google_cloudfunctions2_function" "this" {
  name        = var.name
  location    = var.location
  description = var.description
  project     = var.project
  labels      = var.labels

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.this.id
        object = google_storage_bucket_object.this.name
      }
    }
  }

  service_config {
    min_instance_count             = var.min_instance_count
    max_instance_count             = var.max_instance_count
    timeout_seconds                = var.timeout_seconds
    environment_variables          = var.environment_variables
    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = var.all_traffic_on_latest_revision
  }
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "/tmp/${var.name}.zip"
  source_dir  = "${path.module}/../src"
  excludes    = var.excludes
}

resource "google_storage_bucket" "this" {
  name                        = var.bucket_name
  project                     = var.project
  location                    = var.bucket_location
  force_destroy               = true
  uniform_bucket_level_access = true
  storage_class               = var.bucket_storage_class

  versioning {
    enabled = var.bucket_versioning
  }
}

resource "google_storage_bucket_object" "this" {
  name   = "${var.name}.${data.archive_file.this.output_sha}.zip"
  bucket = google_storage_bucket.this.id
  source = data.archive_file.this.output_path
}
