# yams_data_auditing

A collection of scripts and queries for auditing and updating data in ArchivesSpace. Managed by the Yale Archival Management Systems committee (YAMS)

## Requirements

* ArchivesSpace 2.4+
* Access to ArchivesSpace MySQL database
* For remediation scripts:
  * Python 3.4+
  * `requests` module
  * Access to ArchivesSpace API

## Audit Queries

### get_unstructured_dates.sql

Retrieves all dates which have a value in the expression field but no value in the structured field(s).

### get_identifiers.sql

Retrieves all identifiers which have a value in the id_1 field.

### get_note_labels.sql

Retrieves all notes which have labels.

### get_container_types.sql

Retrieves all containers which have no container type attached.

### get_containers_missing_barcodes_locs.sql

Retrieves all containers which have no associated barcode or location.

### get_user_permissions.sql

Retrieves a list of inactive users.

### get_controlled_values.sql

Retrieves a list of controlled values and their usage frequency

### get_agents_and_subjects.sql

Retrieves a list of agents and subjects created since a given date

## Remediation Scripts

### normalize_dates.py

Run the [timetwister](https://github.com/alexduryee/timetwister) application over a CSV of unstructured dates and return structured dates in a new CSV file. 

### update_identifiers.py

Update identifiers so the entire identifier is in the id_0 field

### delete_note_labels.py

Delete note labels from ArchivesSpace

### add_container_types.py

Create container types for a list of ArchivesSpace top containers

### delete_unassoc_containers.py

Delete unassociated top container records from ArchivesSpace

### deactivate_users.py

Remove the permissions of one or more ArchivesSpace users.
