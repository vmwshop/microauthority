# MicroAuthority

If you've got a list of people and you'd like to publish them on the web as Linked Open Data, MicroAuthority is a simple, bare-bones system that provides an API, search, and other tools for developers and digital researchers.

MicroAuthority creates both HTML & Linked Open Data endpoints for institutional Agent authority files—lists of people, organizations, and groups. Data is provided by the institution as a CSV file. MicroAuthority automatically creates a unique URI for every row in that CSV file that works as both a webpage and as machine-readable Linked Open Data.

This has only been tested on datasets in the ~20,000 row size as of yet—it should scale to ~100,000 (or perhaps more), but nobody's tried yet.  Beta software, etc, etc.

## Getting Started

You should [fork](https://github.com/arttracks/microauthority#fork-destination-box) and then clone this repository to get started.  One you have a copy of it locally, you should modify the `data/data.csv` file to reflect your own data.  Don't worry about missing data for columns—you don't have to fill them all in.  

You should also edit the `config/settings.yaml` file to add your institution specific information, such as your name, url, and the domain you'll be hosting this on.

To test it locally, you need to do the following:

```
bundle install
rake sitemap:create
foreman start
```


There is no database used for this project and no additional software needed.  I recommend deploying it to something like Heroku—there's not a lot of dependencies involved.

## Credit and the Like

Feel free to take this, fork it, and use it as you like.  We'd really appreciate a link or a thanks as part of your deployment, but there's no requirement to do so.

Go ye, and make the web more link-tastic!

**MicroAuthority** is a project of the <a href='http://www.museumprovenance.org'>Art Tracks</a> program at <a href='http://www.cmoa.org'>Carnegie Museum of Art</a>.Funding has been provided by the <a href='http://www.neh.gov/'>National Endowment for the Humanities</a>.