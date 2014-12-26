# ToDo!
+ Verify user access control
+ User things
    + Adding/Removing/Editing Trusted Apps
    + Adding/Removing/Editing Users

+ Verify trusted app access control
    + Access control maybe should be written 
        as a custom method in either ability.rb 
        or application controller

        + Looks like it needs to be in application controller...
        DONE
    + Rating                    DONE
        + If correct permissions, should be
            able to create rating..
    + Recording service         DONE
    + Everyone can read         DONE

    + Access control for... 
        + consumers
            + Only needed for feedback -> can be "inherited" from ratings/services

        + violations
        + permits
            + creation
                + How should I designate the "recipient" of the permit?
                    + vehicle, company, or person?
                    + For now, I might make it simply require the vehicle, company or person
                      to be already created in the database. It would be tough to create the 
                      vehicle/company/person with all necessary relationships as a builder...

                    + Options:
                        + person: id -- Consider creating a uuid for the user
                        + company: name
                        + vehicle: license_plate
        + people
        + companies
        + vehicles
            + How should I handle permissions for creating people, companies, vehicles?
                + Should these be service_type specific?
                    + Doesn't really make sense for them to be service_type specific...

            + BUILDER
                + The best way to do this is probably with a builder... This way, permissions 
                  will at least make sense.

            + NO BUILDER
                + Updating will be more straight forward
                + Permissions will be a challenge...
                    + Currently, permissions are service_type specific (rating, recording services)
                    + However, vehicles, people and companies don't have an inherent service_type...

                + Solutions:
                    + Let the client set the service_type
                        + bad -> don't like the honesty policy
                          as the vehicles they are adding may or may not be for the service_type

                        + this means that we could basically ignore the service_type for 
                          these permissions
                            + bad -> creates excess entries in the database 





        How should I group the permissions?
            + violations should be it's own thing
                + MANAGE_VIOLATIONS
            + companies, vehicles, people all depend on permits
                (technically, the other way around)
                + Static permissions for these types
                    + Static Permissions for these consist of 2 things:
                        + Target
                            + companies
                            + vehicles
                            + person
                        + Action
                            + create, update, delete, all

        May not need the following
        + service_types ?

        Consider moving authentication of trusted apps to common method in base_controller
        Then use before_action
            DONE

+ Seeds for db
    + Admin user
    + Taxi service type
    DONE

+ Additional things
    + Trusted App should probably have contact information for lead dev (in case of problem)
        + email
        + URL
    + Trusted App should probably be showcased on the main page (non essential)

    + Manage namespace
        + Consider adding a side panel (drawer) in the admin view
        + Consider adding a landing stats page for the admin view
    + Add images for drivers/companies
    + Create nice manage permits ui

    + Company
        + URL
        + Phone number
        + Picture? If so, can probably use one from their website

    + TESTING
        + modify permissions (capybara)
