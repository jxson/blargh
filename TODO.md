Soon:

* post attrs need to override layout locals
* posts layout defaults to default
* feature a post with a custom layout
* rss
* favicon
* new blog generation
* generators
** posts
** pages
** views
** layouts

Later:

* extract finders and persistence into a module to use for pages and posts
* respect the publish attr
* slug assignment needs to account for 2010-12-14
* find by stamp (:month-:day-:year)
* revamp the posts and pages api per: http://railstips.org/blog/archives/2010/10/24/the-chain-gang
* attribute typecasting
* get posts to work with factory girl
* cache on request in envs != dev or test
* refactor code to use modules
* tag/ category support
* markdown support
* cache via cli to avoid dependency on a rack server

Much later:

* any other markup support
* mountable
* compactor
* rails 3 integration with generators and mount-ability
* swappable back ends, Active record, mongoid, custom, etc.
* post admin for non git backends

Much Much later:

* configurable routing
* importer/ exporter
** wordpress
** custom
** typo
** mephisto
** tumblr
