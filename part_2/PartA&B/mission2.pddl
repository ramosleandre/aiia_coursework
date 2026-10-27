(define (problem lunar-mission-2)
    (:domain lunar)

    (:objects
        lander1 lander2 - lander
        rover1 rover2 - rover
        wp1 wp2 wp3 wp4 wp5 wp6 - waypoint
        image1 image2 - image
        scan1 scan2 - scan
        sample1 sample2 - sample
    )

    (:init
        (owned_by rover1 lander1)
        (owned_by rover2 lander2)

        (deployed rover1)
        (rover_at rover1 wp2)
        (lander_at lander1 wp2)

        (onboard rover2 lander2)
        (lander_at lander2 wp2)

        (memory_free rover1)
        (memory_free rover2)
        (sample_capacity_free rover1)
        (sample_capacity_free rover2)

        (lander_sample_capacity_free lander1)
        (lander_sample_capacity_free lander2)

        (connected wp1 wp2)
        (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp2 wp4)
        (connected wp4 wp2)
        (connected wp3 wp5)
        (connected wp5 wp3)
        (connected wp5 wp6)
        (connected wp6 wp4)

        (data_at image1 wp3)
        (data_at scan1 wp6)
        (data_at image2 wp2)
        (data_at scan2 wp4)

        (sample_at sample1 wp5)
        (sample_at sample2 wp1)


    )

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