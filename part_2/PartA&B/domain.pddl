(define (domain lunar)
    (:requirements :strips :typing)
    ; Domain definition for the lunar mission
    (:types
        lander
        rover
        waypoint
        data
        sample
        image scan - data
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

    )

    ; -------------------------------
    ; Actions
    ; -------------------------------
    ;move description: move a rover from one waypoint to another
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
    ;deploy description: deploy a rover from a lander to a waypoint
    (:action deploy
        :parameters (?r - rover ?l - lander ?w - waypoint)
        :precondition (and 
            (owned_by ?r ?l)
            (onboard ?r ?l)
            (lander_at ?l ?w)
         )
        :effect (and 
            (not (onboard ?r ?l))
            (deployed ?r)
            (rover_at ?r ?w)
        )
    )
    ;capture_image description: capture an image with a rover
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
    ;perform_scan description: perform a scan with a rover
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
    ;transmit_data description: transmit data from a rover to a lander
    (:action transmit_data
        :parameters (?r - rover ?l - lander ?d - data)
        :precondition (and
            (deployed ?r)
            (owned_by ?r ?l)
            (carrying_data ?r ?d)
        )
        :effect (and
            (not (carrying_data ?r ?d))
            (saved_data ?d ?l)
            (memory_free ?r)
        )
    )
    ;collect_sample description: collect a sample with a rover
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
    ;store_sample description: store a sample in a lander
    (:action store_sample
        :parameters (?r - rover ?s - sample ?l - lander ?w - waypoint)
        :precondition (and
            (deployed ?r)
            (owned_by ?r ?l)
            (rover_at ?r ?w)
            (lander_at ?l ?w)
            (carrying_sample ?r ?s)
            (lander_sample_capacity_free ?l)
        )
        :effect (and
            (not (carrying_sample ?r ?s))
            (not (lander_sample_capacity_free ?l))
            (stored_sample ?s ?l)
            (sample_capacity_free ?r)
        )
    )
    

)

