# date normalization

Queries and scripts to identify and normalize unstructured dates. 

# Requirements

* Python 3.4+
* ArchivesSpace 2.1+
* Access to ArchivesSpace database
* Access to ArchivesSpace API
* MySQL client
* Ruby 2.0+
* [Timetwister](https://github.com/alexduryee/timetwister)

# Tutorial

What follows is a potential workflow for identifying and normalizing unstructured date records in ArchivesSpace.

## Step 1: Identifying unstructured dates with `get_unstructured_dates.sql`

This query will return a report of all date records in ArchivesSpace which have a value in the _expression_ field but which do not have values in the _begin_ or _end_ fields.

The output of this report should be used as the input for `parse_dates.py`.

## Step 2: Parsing unstructured dates with `parse_dates.py`

To run this script:

```
$ cd git/yams_data_auditing/dates
$ python parse_dates.py
``` 
And follow the prompts in the terminal.

**NOTE:** This script was written on/for the OSX operating system. It may work on a PC but it has not yet been tested.

## Step 3a: Updating dates via ArchivesSpace database

This is the most accurate method to update records in the date table, as it uses the date subrecord's database ID to identify and update the record. However, subrecords in ArchivesSpace are not persistent - every time a top-level record (resource, archival object, etc.) is saved, all associated subrecords are deleted and recreated, and thus are assigned a new database ID. It is recommended to run the `parse_dates.py` script as close to the time of update as possible, so that fewer database IDs will have changed. It may be useful to run the `parse_dates.py` script, perform quality control on the results, and then run it again immediately before the SQL update.

### Preparing inputs

Three possible date types are returned by the `parse_dates.py` script:
* Single: value in the _begin_ field but not the _end_ field. The date type ID for single dates is **903**
* Single/Inclusive: value in the _end_ field but not the begin field. This is an inclusive date with a single value. The date type ID for inclusive dates is **905**
* Inclusive: values in both the _begin_ and _end_ fields. THe date type ID for inclusive dates is **905**

Because of the variations in these three date types, it is necessary to create three input CSVs, one for each date type. It is also necessary to create a temporary database table for each type, and to run the update script separately for each. Running them all at the same time introduces erroneous NULL values among other problems.

Use the `split_outputs.py` script to create a CSV file for each date type.

### Creating temporary tables using `create_datetemp_table.sql`

Execute this script in a MySQL client or CLI. Be sure to comment out the correct lines depending on the date type. Create different temporary tables for inclusive and single date records.

Once the temporary tables are created, import your input spreadsheets into the tables. The exact process for doing this will depend on the MySQL client you are using.

### Running `update_dates.sql`

To make the updates, execute this script. Be sure to comment out the correct lines depending on the date type. The script must be run separately for each date type.

## Step 3b: Updating dates via the ArchivesSpace API

This method of updating date subrecords is less accurate, as it requires matching by URI and date expression, a free-text field, rather than by the date ID. However, users may favor this option if performing an SQL update is undesirable, and if there is concern about the changing of date subrecord database IDs.

### Preparing inputs

It is ok to use a single spreadsheet for all date types, though 

### Running `update_dates_by_expression.py`

# Other Useful Tools

## get_aos_without_dates.sql

Retrieves a report of archival objects which are lacking date subrecords






