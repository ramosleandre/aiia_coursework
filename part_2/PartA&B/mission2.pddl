(define (problem lunar-mission-2)
    (:domain lunar)
    ; Problem definition for the second lunar mission
    (:objects
        lander1 lander2 - lander
        rover1 rover2 - rover
        wp1 wp2 wp3 wp4 wp5 wp6 - waypoint
        image1 image2 - image
        scan1 scan2 - scan
        sample1 sample2 - sample
    )

    (:init
        ;rover1 is deployed and rover2 is onboard lander2
        (owned_by rover1 lander1)
        (owned_by rover2 lander2)

        ;rover1 is deployed and at wp2, lander1 is at wp2
        (deployed rover1)
        (rover_at rover1 wp2)
        (lander_at lander1 wp2)
        
        ;rover2 is onboard lander2 and at wp2
        (onboard rover2 lander2)
        (lander_at lander2 wp2)
        
        ;limited memory and sample capacity
        (memory_free rover1)
        (memory_free rover2)
        (sample_capacity_free rover1)
        (sample_capacity_free rover2)
        
        ;limited sample capacity on the landers
        (lander_sample_capacity_free lander1)
        (lander_sample_capacity_free lander2)

        ;waypoint connectivity bi-directional
        (connected wp1 wp2)
        (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp2 wp4)
        (connected wp4 wp2)
        (connected wp3 wp5)
        (connected wp5 wp3)
        (connected wp5 wp6)
        (connected wp6 wp4)

        ;data and sample locations
        (data_at image1 wp3)
        (data_at scan1 wp6)
        (data_at image2 wp2)
        (data_at scan2 wp4)

        ;sample data locations
        (sample_at sample1 wp5)
        (sample_at sample2 wp1)


    )
    ; Goal: transmit all data and store all samples
    (:goal
        (and
            (saved_data image1 lander1)
            (saved_data scan1 lander1)
            (saved_data image2 lander2)
            (saved_data scan2 lander2)
            (stored_sample sample1 lander1)
            (stored_sample sample2 lander2)
        )
    )
)