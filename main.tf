resource "google_storage_bucket" "upload" {
    name = "foruploada06"
    location = "us-central1"
}

resource "google_storage_bucket" "give_result" {
    name = "forresulta06"
    location = "us-central1"
}

resource "google_storage_bucket" "image_bucket" {
    name = "forimagea06"
    location = "us-central1"
}

/*resource "google_storage_bucket_object" "gcs2bq-1" {
    name = "gcs2bq-1"
    bucket = google_storage_bucket.upload.name
    source = "gcs2bq-1.zip"
}*/

resource "google_storage_bucket_object" "vision" {
    name = "vision"
    bucket = google_storage_bucket.upload.name
    source = "vision.zip"
}

/*resource "google_cloudfunctions_function" "gcs2bq-1" {
  name = "gcs2bq-1"
  runtime = "python310"
  description = "google cloudstorage to bigquery"

  available_memory_mb = 256
  source_archive_bucket = google_storage_bucket.upload.name
  source_archive_object = google_storage_bucket_object.gcs2bq-1.name

  trigger_http = false

  event_trigger {
    event_type = "google.storage.object.finalize"
    bucket     = "forresulta06"
  }
  entry_point = "gcs2bq"
}*/

resource "google_cloudfunctions_function" "vision" {
  name = "vision"
  runtime = "python310"
  description = "visionning"

  available_memory_mb = 256
  source_archive_bucket = google_storage_bucket.upload.name
  source_archive_object = google_storage_bucket_object.vision.name

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource     = google_storage_bucket.image_bucket.name
  }
  entry_point = "async_detect_document"
}

/*resource "google_cloudfunctions_function_iam_member" "allow_access_tff" {
  region = google_cloudfunctions_function.vision.region
  cloud_function = google_cloudfunctions_function.vision.name

  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}*/