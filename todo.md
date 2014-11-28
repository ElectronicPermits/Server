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
        + vehicles
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

        How should I group the permissions?
            + violations should be it's own thing
                + MANAGE_VIOLATIONS
            + companies, vehicles, people all depend on permits
                (technically, the other way around)

                + MANAGE_PERMITS

        May not need the following
        + service_types ?

        Consider moving authentication of trusted apps to common method in base_controller
        Then use before_action

+ Seeds for db
    + Admin user
    + Taxi service type
