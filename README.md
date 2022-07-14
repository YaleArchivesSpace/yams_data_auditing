# yams_data_auditing

A collection of scripts and queries for auditing and updating data in ArchivesSpace. Managed by the Yale Archival Management Systems committee (YAMS)

This repository is in active development. See this [document](https://docs.google.com/document/d/19W15_yW1aFVy2Uzz9bLUGy_eNBiBXXHpKaC6pN738kM) for details on future additions to the auditing queries.

### Requirements

* ArchivesSpace 2.4+
* Python 3.4+
* `requests`
* `sshtunnel`
* `pymysql`
* `utilities` local Python package

### Getting Started

To connect to the ArchivesSpace database, enter credentials into `config_template.yml` and change name to `config.yml`. The `DBConn` class in  `db_conn_ssh.py` will look in the current directory for the config file. To run a query, enter the following into a Terminal:

```
$ cd /Users/username/filepath
$ python
Python 3.6.2 |Anaconda custom (x86_64)| (default, Sep 21 2017, 18:29:43)
[GCC 4.2.1 Compatible Clang 4.0.1 (tags/RELEASE_401/final)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import db_conn_ssh as db
>>> as_db = db.DBConn()
>>> q = 'SELECT title from archival_object LIMIT 10'
>>> results = as_db.run_query(q)
>>> print(results)
                                               title
0  Yale Bowl materials collected by Charles A. Ferry
1                                     Correspondence
2                     Proposed Yale Bowl Memorabilia
3                                        Photographs
4                        Charles A. Ferry Bowl model
5                            First batch of concrete
6                                 Construction album
7                         Miscellaneous construction
8                                        Bowl filled
9                                          Contracts
```

Audit queries in this repository can be run individually, or can be run in bulk by executing `run_queries.py`. An input (location of the queries) and output (where results should be stored) directory, as well as any exclusions (any .sql files that should not be run) must be specified in the `config.yml` file. To run `run_queries.py`, enter the following into a Terminal:

```
$ cd /Users/username/filepath
$ python run_queries.py
```

The `run_queries.py` script can also be set to run as a cron job or Windows Scheduler task, or automated with a Python scheduler module such as `apscheduler`.

Update scripts are intended to be run separately based on the results of the audit queries.

### Utilities

##### `db_conn_ssh.py`

Script to connect to ArchivesSpace database via SSH.

##### `run_queries.py`

Search for queries in user-defined directory and execute each, saving output to specified directory. Exclusions can be defined in `config.yml` file.

##### `utilities.py`

Assorted utility scripts for logging into the ArchivesSpace API, file handling, logging, etc.

##### `delete_records.py`

Script to delete top-level records. Can be used to delete "orphan" agent and subject records, unassociated containers and digital objects, etc.

### Agents and Subjects

##### `get_all_agents.sql`

Retrieves a list of all agent records.

##### `get_all_subjects.sql`

Retrieves a list of all subject records.

##### `get_subjects.py`

Script to retrieve all subject records via ArchivesSpace API

##### `get_agents.py`

Script to retrieve all agent records via ArchivesSpace API

##### `all_agent_links.sql`

Retrieves all agents linked to descriptive records.

##### `all_subject_links.sql`

Retrieves all subjects linked to descriptive records.

##### `linked_agent_count.sql`

Retrieves a count of agents linked to descriptive records

##### `linked_subject_count.sql`

Retrieves a count of subjects linked to descriptive records.

##### `name_corporate_entity_source_count.sql`

Gets a count of sources (i.e. LCNAF) used in corporate entity name records.

##### `name_family_source_count.sql`

Gets a count of sources used in family name records.

##### `name_person_source_count.sql`

Gets a count of sources used in personal name records.

##### `subject_source_count.sql`

Gets a count of sources used in subject records.

##### `get_agent_orphans.sql`

Retrieves a list of agents not linked to descriptive records.

##### `get_subject_orphans.sql`

Retrieves a list of subjects not linked to descriptive records.

##### `dupe_finder.py`

Processes output of `get_all_agents.sql`, `get_all_subjects.sql`, `get_agents.py`, or `get_subjects.py` and returns potential duplicate agent and subject records.

##### `merge_records.py`

Merges duplicate agent or subject records.

### Containers and Digital Objects

##### `get_boxes_missing_types.sql`

Retrieves all top containers without a container type.

##### `get_unassociated_containers.sql`

Retrieves all containers not associated with an archival object instance.

##### `get_unassociated_dig_objects.sql`

Retrieves all digital objects not associated with an archival object instance.

##### `reorder_dig_objects.py`

Changes position of digital object records according to user specifications.

### Controlled Values

##### `container_profile_count.sql`

Retrieves a count of container profiles currently in use.

##### `extent_type_count.sql`

Retrieves a count of extent types currently in use.

##### `get_controlled_values.sql`

Retrieves a list of controlled values. Includes values not in use.

##### `material_type_count.sql`

Retrieves a count of material types currently in use.

##### `update_enumeration_value_position.py`

Change position of enumeration values according to user specifications.

##### `merge_enumeration_values.py`

Merges duplicate enumeration values.

##### `delete_enumeration_values.py`

Deletes unused enumeration values from the database.

### Dates

See separate date [README](https://github.com/YaleArchivesSpace/yams_data_auditing/blob/master/dates/README.md) for detailed instructions on running date auditing queries and normalization scripts.

### File Versions

See separate file version [README](https://github.com/YaleArchivesSpace/yams_data_auditing/tree/master/file_versions/README.md) for detailed instructions on running file version audit and update scripts.

### Finding Aid as CSV

#####  `finding_aid_as_csv.sql`

Returns a rough representation of a finding aid in CSV format.

### Identifiers

##### `get_split_identifiers.sql`

Retrieves a list of resources with identifiers split across multiple fields.

##### `update_identifiers.py`

Moves split identifiers into 'id_0' field.

### Labels

##### `get_all_notes.sql`

Retrieves all notes. Can be limited to return certain types.

##### `extract_note_labels.py`

Executes `all_notes.sql` query and returns an analysis of note label usage.

##### `remove_note_labels.py`

Removes note labels.

### Users

##### `get_all_permissions.sql`

Retrieves a list of all users with permissions. Used to analyze the permissions of active users.

##### `get_users_withorwithoutperms.sql`

Retrieves a list of all users with or without permissions. Used to identify inactive users.

### Links

##### `get_links.sql`

Retrieves a list of external links used in notes and digital object records.

##### `check_links.py`

Executes `get_links.sql` query and checks the results for broken links.

### Restrictions

##### `get_access_notes.sql`

Retrieves all free-text access notes.

##### `get_machine_actionable_restrictions.sql`

Retrieves all machine-actionable restrictions.

##### `get_all_restrictions.sql`

Retrieves all restriction notes + machine actionable restrictions.
