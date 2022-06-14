# FE Analylitcal Page

This repo is a place for testing the interaction of CAP and FE.

Currently there is NO deployment configuration.
Similarly, there is also no sophisticated approch to serving the frontend applications. These live in their own folders and are served locally when needed.

You can start the app with the following commands:
```sh
cds watch
cd analytical1.96.9 && npm start 
cd ovphorizon && npm start
```

## How to get more Nast data

There is a csv file with sample data already provided, which gets loaded on database setup.

If you want to extend that data from an on premise SAP system, run a Report with similar code as shown below on your SAP system from Hana Studio:

```ABAP
REPORT zthe_steal_nast.

select * From /btl/tr_nast into table @data(lt_res) up to 20 rows.

BREAK-POINT.
```

Then copy the data from the internal table into a file called `nast.csv`. This can be done by right clicking on the table data in debugger and selecting `Export to File...`. Be sure to update the file extension to `.csv`.

Then open the file in Excel and remove the first and last column.
Save the file into `./db/data` as `db.NAST.csv`.

The updated content of the file will be served by CAP.

If you want to use CHGTST, GEO lat & lon you may have to adjust the format of those numbers (only one `.` allowed).

## Getting Started

Welcome to your new project.

It contains these folders and files, following our recommended project layout:

File or Folder | Purpose
---------|----------
`app/` | content for UI frontends goes here
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`package.json` | project metadata and configuration
`readme.md` | this getting started guide

## Next Steps

- Open a new terminal and run `cds watch`
- (in VS Code simply choose _**Terminal** > Run Task > cds watch_)
- Start adding content, for example, a [db/schema.cds](db/schema.cds).


## Learn More

Learn more at https://cap.cloud.sap/docs/get-started/.
