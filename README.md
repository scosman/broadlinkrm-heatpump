# BroadlinkRM Heatpump/Split-AC IR Codes

This project is a repository of IR codes to control mini-split airconditions and/or heatpumps.

Currently I have codes for Fujitsu-Halcyon heatpumps. I plan on adding Mitsubishi soon. 

These codes work on my model, but your milage may vary.

## BroadlinkRM Accessories JSON

The json files in the `Broadlink RM Pro Accessories` directory are designed to be used with the [Homebridge Broadlink RM Pro Plugin](https://github.com/kiwi-cam/homebridge-broadlink-rm#readme) to [Homebridge](https://homebridge.io). This exposes the heatpump as an accessory in HomeKit, and allows you to control it from relatively inexpensive wifi connected IR blasters you can buy online.

To use, first setup Homebride and the Broadlink RM Pro Plugin. Then simply copy the json for the appriopiate brand to your accessory list in Homebridge config.

If you have several heatpumps, create several accessories using this json as the template. Give each a unique name (the 'name' property in json), and add a 'host' property with the mac address of the Broadlink RM adapter in the room of the heatpump you want to control. The host property will allow you to control individual rooms instead of sending to all rooms at the same time.

## Raw Codes

The raw codes are available in CSV files in the `Raw Codes` subdirectory. These can be used with other IR blasting tools.

## Ruby script

I've included a ruby script which builds the JSON Broadlink RM accessories json from the CSV files. This isn't designed to be super reusable, just a quick hack, but including for any engineers who have more complicated use cases and find it useful. Most people should use the generated JSON files directly.

## Contributing

If you'd like to contribute (more brands, or more complete codes with additional fan modes), please send a PR.

