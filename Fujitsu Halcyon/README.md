# Important

These are learned using the broadlink homebridge plugin.

Important: these are the "on" commands for these temperatures. 

To learn:

 - Set the remote to the settings you want (fan level, tilt, etc). We only have 1 setting per temp for simplicity, so whole file should match for these settings.
 - Set the remote "mode" to cool or heat. The CSV Mode column should have the right value here. Valid values are "Heat", "Cool" and "Off" (one code to turn it off)
 - **Important**: These need to be the "on" code for that temperature. The remote sends different codes based on it's state. If it's on and just changing temp, it sends a code that won't turn on the unit. We want every code to turn on the unit (if off) as this is used when you turn it on. To "learn" the on code: set the config you want on remote, turn off (remote now blank), start learning, hit power button. If you're learning the up/down buttons, you're learning the wrong button.