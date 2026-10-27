(define (domain lunar-extended)
    (:requirements :strips :typing)


    ; (:types
    ;     parent_type
    ;     child_type - parent_type

    ; )
    (:types
        lander
        rover
        waypoint
        data
        sample
        image scan - data
        astronaut
        area
        control_room docking_bay - area
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------

    (:predicates

        ; positions and connectivity
        (rover_at ?r - rover ?w - waypoint)
        (lander_at ?l - lander ?w - waypoint)
        (connected ?w1 - waypoint ?w2 - waypoint)
        
        ; deployment and ownership
        (deployed ?r - rover)
        (onboard ?r - rover ?l - lander)
        (owned_by ?r - rover ?l - lander)

        ; data and rover memory
        (data_at ?d - data ?w - waypoint)
        (memory_free ?r - rover)
        (carrying_data ?r - rover ?d - data)
        (saved_data ?d - data ?l - lander)

        ;samples
        (sample_at ?s - sample ?w - waypoint)
        (sample_capacity_free ?r - rover)
        (carrying_sample ?r - rover ?s - sample)
        (lander_sample_capacity_free ?l - lander)
        (stored_sample ?s - sample ?l - lander)

        ; astronauts
        (astronaut_at ?a - astronaut ?ar - area)
        (astronaut_belongs ?a - astronaut ?l - lander)

        ; areas
        (area_in ?a - area ?l - lander) 

    )

    ; -------------------------------
    ; Actions
    ; -------------------------------

    (:action move
        :parameters (?r - rover ?from - waypoint ?to - waypoint)
        :precondition (and
            (rover_at ?r ?from)
            (connected ?from ?to)
            (deployed ?r)
        )
        :effect (and
                (not (rover_at ?r ?from))
                (rover_at ?r ?to)
        )
    )
    (:action deploy
        :parameters (?r - rover ?l - lander ?w - waypoint ?a - astronaut ?db - docking_bay)
        :precondition (and 
            (owned_by ?r ?l)
            (onboard ?r ?l)
            (lander_at ?l ?w)
            (astronaut_belongs ?a ?l)
            (astronaut_at ?a ?db)
            (area_in ?db ?l)
         )
        :effect (and 
            (not (onboard ?r ?l))
            (deployed ?r)
            (rover_at ?r ?w)
        )
    )
    (:action capture_image
        :parameters (?r - rover ?i - image ?w - waypoint)
        :precondition (and
            (deployed ?r)
            (rover_at ?r ?w)
            (data_at ?i ?w)
            (memory_free ?r)
        )
        :effect (and 
            (not (memory_free ?r))
            (carrying_data ?r ?i)
        )
    )
    (:action perform_scan
        :parameters (?r - rover ?s - scan ?w - waypoint)
        :precondition (and 
            (deployed ?r)
            (rover_at ?r ?w)
            (data_at ?s ?w)
            (memory_free ?r)
        )
        :effect (and 
            (not (memory_free ?r))
            (carrying_data ?r ?s)
        )
    )
    (:action transmit_data
        :parameters (?r - rover ?l - lander ?d - data ?a - astronaut ?cr - control_room)
        :precondition (and
            (deployed ?r)
            (owned_by ?r ?l)
            (carrying_data ?r ?d)
            (astronaut_belongs ?a ?l)
            (astronaut_at ?a ?cr)
            (area_in ?cr ?l)
        )
        :effect (and
            (not (carrying_data ?r ?d))
            (saved_data ?d ?l)
            (memory_free ?r)
        )
    )
    (:action collect_sample
        :parameters (?r - rover ?s - sample ?w - waypoint)
        :precondition (and
            (deployed ?r)
            (rover_at ?r ?w)
            (sample_at ?s ?w)
            (sample_capacity_free ?r)
        )
        :effect (and
            (not (sample_capacity_free ?r))
            (not (sample_at ?s ?w))
            (carrying_sample ?r ?s)
        )
    )
    (:action store_sample
        :parameters (?r - rover ?s - sample ?l - lander ?w - waypoint ?a - astronaut ?db - docking_bay)
        :precondition (and
            (deployed ?r)
            (owned_by ?r ?l)
            (rover_at ?r ?w)
            (lander_at ?l ?w)
            (carrying_sample ?r ?s)
            (lander_sample_capacity_free ?l)
            (astronaut_belongs ?a ?l)
            (astronaut_at ?a ?db)
            (area_in ?db ?l)
        )
        :effect (and
            (not (carrying_sample ?r ?s))
            (not (lander_sample_capacity_free ?l))
            (stored_sample ?s ?l)
            (sample_capacity_free ?r)
        )
    )
    (:action move_astronaut
        :parameters (?a - astronaut ?from - area ?to - area ?l - lander)
        :precondition (and 
            (astronaut_belongs ?a ?l)
            (astronaut_at ?a ?from)
            (area_in ?from ?l)
            (area_in ?to ?l)
        )
        :effect (and 
            (not (astronaut_at ?a ?from))
            (astronaut_at ?a ?to)
        )
    )
    

)

