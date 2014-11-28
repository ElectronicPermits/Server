# API Documentation
This is a (rough) list of the documentation. All the endpoints are V1 and the endpoints should be prepended with "/v1".

### POST /ratings
+ app\_signature
+ rating
+ comments (optional)
+ consumer\_id
+ permit\_beacon\_id || permit\_number

### POST /services
+ app\_signature
+ consumer\_id
+ permit\_beacon\_id || permit\_number

Optional:
+ service:
    + start\_latitude
    + start\_longitude
    + end\_latitude
    + end\_longitude
    + start\_time
    + end\_time
    + estimated\_cost
    + actual\_cost
