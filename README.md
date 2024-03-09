Assorted UI tweaks provided by Varzof.

# Features

* [Un-track completed achievements](#un-track-completed-achievements) workaround

## Un-track completed achievements

In some cases, tracked achievements remain tracked after the achievement has been completed.
This most often happens when the achievement is completed on a different character on the same account.
In this situation, the tracked achievement continues to count against your maximum number of tracked achievements (10), despite not actually showing anything in the tracker.
If you attempt to track an achievement and get the error "You may only track 10 achievements at a time.", despite not having 10 tracked achievements, you are impacted by this bug.
This add-on scans your tracked achievements on startup and calls out any completed achievements that can be safely un-tracked.
If you enable the "Un-track completed achievements" option, it will also un-track said achievements automatically.
