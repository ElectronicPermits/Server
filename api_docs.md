# API Documentation
This is a (rough) list of the documentation. All the endpoints are V1 and the endpoints should be prepended with "/v1".

## Feedback
### POST /ratings
+ app\_signature
+ consumer\_id
+ permit\_beacon\_id || permit\_number

Optional:
+ rating
    + rating (number)
    + comments (optional)

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

## Issuing Violations
### POST /violations (Creation)
+ app\_signature
+ consumer\_id? Not yet...
+ permit\_beacon\_id || permit\_number

+ violation
    + name
    + description
    + ordinance
    + issue\_date
    + open

### PATCH/PUT /violations/id (Update)

## Managing Permits
### POST /permits (Creation)
+ permit
    + service\_type (name) (REQUIRED)
    + permitable (REQUIRED)
    + permit\_number (REQUIRED)
    + beacon\_id (REQUIRED)
    + status
    + valid
    + training\_completion\_date
    + permit\_expiration\_date

# Notes
Consumer id should be anonymized! All data is public information!
