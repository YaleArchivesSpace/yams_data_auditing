# date normalization

A process to identify and normalize unstructured dates in ArchivesSpace. 

## Requirements

* Python 3.4+
* ArchivesSpace 2.1+
* Access to ArchivesSpace database
* Access to ArchivesSpace API
* MySQL client
* Ruby 2.0+
* [Timetwister](https://github.com/alexduryee/timetwister)

**NOTE:** This script was written on/for the OSX operating system. It may work on a PC but it has not yet been tested.

## Tutorial

### Step 1: Identifying unstructured dates with `get_unstructured_dates.sql`

This query will return a report of all date records in ArchivesSpace which have a value in the _expression_ field but which do not have values in the _begin_ or _end_ fields.

The output of this report should be used as the input for `parse_dates.py`.

### Step 2: Parsing unstructured dates with `parse_dates.py`

To run this script:

```
$ cd git/yams_data_auditing/dates
$ python parse_dates.py
``` 
Follow the prompts in the terminal:

1. _Please enter path to log file_ - enter the desired file name or path for your log file. Ex: _log.log_ or _/Users/username/folder/log.log
2. _Please enter path to CSV_ - enter the filename or path to your input CSV file.
3. _Please enter path to output CSV_ -  enter the filename or path to your output CSV file
4. _Enter "Y" to split output into multiple spreadsheets by date type, or any key to continue_ - indicate whether you'd like a set of subreports to be produced in addition to the output CSV. These subreports are used as input for the SQL update scripts described below.

### Step 3a: Updating dates via the ArchivesSpace database

This is the most accurate method to update records in the date table, as it uses the date subrecord's database ID to identify and update the record. However, subrecords in ArchivesSpace are not persistent - every time a top-level record (resource, archival object, etc.) is saved, all associated subrecords are deleted and recreated, and thus are assigned a new database ID. It is recommended to run the `parse_dates.py` script as close to the time of update as possible, so that fewer database IDs will have changed. It may be useful to run the `parse_dates.py` script, perform quality control on the results, and then run it again immediately before the SQL update.

#### Preparing inputs

The `parse_dates.py` script includes options for several output types. In addition to the master report, you can also elect to split the master report into subreports based on the following criteria:

1. _begin_single.csv_ - the same value in both the _begin_ and _end_ field. The date type ID for single dates is **903**
2. _inclusive.csv_ - values in the _begin_ field and the _end_ field. The date type ID for inclusive dates is **905**
3. _begin_inclusive.csv_ - value in the _begin_ field but not the _end_ field. The date type ID for inclusive dates is **905**
4. _end_inclusive.csv_ - value in the _end_ field but not the _begin_ field. The date type ID for inclusive dates is **905**
5. _multiples.csv_ - occasionally `timetwister` parses an unstructured date into multiple dates. This report must be reviewed, as some of the parsed dates may be usable, while others are errors.
6. _unparsed.csv_ - all dates that could not be parsed by `timetwister`
7. _errors_ - all dates that failed to parse due to a program error

Reports 1-4 have date type IDs added, and can be used as input for the `update_dates.sql` script. Reports 5-7 are informational.

#### Creating temporary tables using `create_datetemp_table.sql`

Execute this script in a MySQL client or CLI. Be sure to comment out the correct lines depending on the date type. Create different temporary tables for inclusive and single date records.

Once the temporary tables are created, import your input spreadsheets into the tables. The exact process for doing this will depend on the MySQL client you are using.

#### Running `update_dates.sql`

Execute this script to update your database. Be sure to comment out the correct lines depending on the date type. The script must be run separately for each date type. Running them altogether can lead to erroneous values being introduced into the database due to the differences in the number of fields and in the date types used in each spreadsheet.

### Step 3b: Updating dates via the ArchivesSpace API

This method of updating date subrecords is less accurate, as it requires matching by URI and date expression, a free-text field, rather than by the date ID. However, users may favor this option if performing an SQL update is undesirable, and if there is concern about the changing of date subrecord database IDs.

#### Preparing inputs

It is ok to use the `parse_dates.py` master report for all date types, though the subreports can also be used. If using the master report, delete all 'None' strings in the CSV. Will soon update the script so these are removed before the reports are written.

#### Running `update_dates_by_expression.py`

To run this script:

```
$ cd git/yams_data_auditing/dates
$ python update_dates_by_expression.py
``` 
Follow the prompts in the terminal:

* _Please enter path to log file_- enter the desired file name or path for your log file. Ex: _log.log_ or _/Users/username/folder/log.log
* _Please enter the ArchivesSpace API URL_ - enter your ArchivesSpace API URL
* _Please enter your username_ - enter your ArchivesSpace username
* _Please enter your password_ - enter your ArchivesSpace password
* _Please enter path to CSV_ - enter the filename or path to your input CSV
* _Please enter path to output directory_ - enter the path to where you want to store your backup JSON files

## Other Useful Tools

#### get_aos_without_dates.sql

Retrieves a report of archival objects which are lacking date subrecords






