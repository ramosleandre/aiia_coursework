(define (problem lunar-mission-1)
    (:domain lunar)
    ; Problem definition for the first lunar mission
    (:objects
        lander1 - lander
        rover1 - rover
        wp1 wp2 wp3 wp4 wp5 - waypoint
        image1 - image
        scan1 - scan
        sample1 - sample
    )

    (:init

        ;lannder and rover is in wp1
        (owned_by rover1 lander1)
        (onboard rover1 lander1)
        (lander_at lander1 wp1)
        
        ;limited memory and sample capacity
        (memory_free rover1)
        (sample_capacity_free rover1)
        (lander_sample_capacity_free lander1)

        ;data and sample locations
        (data_at image1 wp5)
        (data_at scan1 wp3)
        (sample_at sample1 wp1)

        ;waypoint connectivity unidirectional
        (connected wp1 wp2)
        (connected wp2 wp3)
        (connected wp1 wp4)
        (connected wp4 wp3)
        (connected wp3 wp5)
        (connected wp5 wp1)
    )
    
    ; Goal: transmit all data and store all samples
    (:goal
        (and
            (saved_data image1 lander1)
            (saved_data scan1 lander1)
            (stored_sample sample1 lander1)
        )
    )
)