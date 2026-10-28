(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
        lander1 - lander
        rover1 - rover
        wp1 wp2 wp3 wp4 wp5 - waypoint
        image1 - image
        scan1 - scan
        sample1 - sample
    )

    (:init
        (owned_by rover1 lander1)
        (onboard rover1 lander1)
        (lander_at lander1 wp1)

        (memory_free rover1)
        (sample_capacity_free rover1)
        (lander_sample_capacity_free lander1)

        (data_at image1 wp5)
        (data_at scan1 wp3)
        (sample_at sample1 wp1)

        (connected wp1 wp2)
        (connected wp2 wp3)
        (connected wp1 wp4)
        (connected wp4 wp3)
        (connected wp3 wp5)
        (connected wp5 wp1)
    )

    (:goal
        (and
            (saved_data image1 lander1)
            (saved_data scan1 lander1)
            (stored_sample sample1 lander1)
        )
    )
)