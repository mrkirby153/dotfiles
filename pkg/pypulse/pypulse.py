#!/usr/bin/env python3

try:
    import pulsectl
    import notify2
    import json
    import os
    import argparse
    import subprocess
    from packaging import version
except Exception as e:
    print(f"Missing dependency. Ensure that pulsectl and notify2 are installed!: {e}")
    exit(1)


CONFIG_LOCATION = os.path.expanduser("~/.pypulse.json")

HEADPHONES = None
SPEAKERS = None

pulse = pulsectl.Pulse("PyPulse")

notify_initialized = False


def load_config():
    global HEADPHONES, SPEAKERS
    if not os.path.exists(CONFIG_LOCATION):
        return
    with open(CONFIG_LOCATION, "r") as cfg_file:
        raw_data = cfg_file.read()
        raw_json = json.loads(raw_data)
        HEADPHONES = raw_json["headphones"]
        SPEAKERS = raw_json["speakers"]

    # Migrate old config to new format
    needs_save = False
    if type(HEADPHONES) is str:
        HEADPHONES = {"name": HEADPHONES, "description": None}
        needs_save = True
    if type(SPEAKERS) is str:
        SPEAKERS = {"name": SPEAKERS, "description": None}
        needs_save = True

    if needs_save:
        print(f"Migrating configuration to new format")
        save_config(HEADPHONES, SPEAKERS)
    validate_config()


def save_config(headphones, speakers):
    struct = {"headphones": headphones, "speakers": speakers}
    with open(CONFIG_LOCATION, "w+") as cfg_file:
        cfg_file.write(json.dumps(struct))
    # print(f"Config written to {CONFIG_LOCATION}: {struct}")


def validate_config():
    global HEADPHONES, SPEAKERS

    def _validate(name, description):
        by_name = find_sink_by_name(name)
        by_description = find_sink_by_description(description)
        if by_name is None and by_description is None:
            print(f"Could not find sink with name {name} or description {description}")
            send_notification(
                f"Sink {description} ({name}) not found", notify2.URGENCY_CRITICAL
            )
        if by_name is None:
            # Was not able to find the name of the sink
            if by_description is not None:
                # Was able to find the sink by description, update the name
                return by_description.name, by_description.description
            else:
                # Was not able to find the sink by description
                return None, None
        else:
            return by_name.name, by_name.description  # Was able to find the sink

    def _update_config(source):
        saved_name = source["name"]
        saved_description = source["description"]
        name, description = _validate(saved_name, saved_description)
        if name is None and description is None:
            return False
        if name != saved_name or description != saved_description:
            source["name"] = name
            source["description"] = description
            return True
        return False

    should_update = False
    if _update_config(HEADPHONES):
        should_update = True
    if _update_config(SPEAKERS):
        should_update = True
    if should_update:
        # print("Saving updated configuration")
        save_config(HEADPHONES, SPEAKERS)


def find_sink_by_name(name: str):
    try:
        return pulse.get_sink_by_name(name)
    except:
        return None


def find_source_by_name(name: str):
    try:
        return pulse.get_source_by_name(name)
    except:
        return None


def find_sink_by_description(description: str):
    for sink in pulse.sink_list():
        if sink.description == description:
            return sink
    return None


def find_source_by_description(description: str):
    for source in pulse.source_list():
        if source.description == description:
            return source
    return None


def find_source(source_name: str, source_description: str):
    print(
        "Finding soruce by name: ", source_name, " or description: ", source_description
    )
    source = find_source_by_name(source_name)
    if source is None:
        source = find_source_by_description(source_description)
    return source


def find_sink(sink_name: str, sink_description: str):
    sink = find_sink_by_name(sink_name)
    if sink is None:
        sink = find_sink_by_description(sink_description)
    return sink


def send_notification(message: str, urgency: int = notify2.URGENCY_NORMAL):
    global notify_initialized
    if not notify_initialized:
        notify2.init("PyPulse")
        notify_initialized = True
    notice = notify2.Notification("PyPulse", message)
    notice.set_urgency(urgency)
    notice.show()


def dmenu_prompt(args, prompt=None):
    cmd = ["dmenu", "-c", "-l", "20", "-i"]
    if prompt is not None:
        cmd.extend(["-p", prompt])
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stdin=subprocess.PIPE)
    (stdout, _) = proc.communicate(input="\n".join(args).encode("utf-8"))
    if proc.returncode != 0:
        return None
    return stdout.decode("utf-8")[:-1]


def set_default(new_sink):
    # Determine the default sink
    default_sink = pulse.server_info().default_sink_name
    print(f"The default sink is currently {default_sink}")

    name, description = new_sink["name"], new_sink["description"]
    new_sink = find_sink(name, description)
    if new_sink is None:
        print(
            f"Could not find sink with name: {new_sink}. Try running the setup wizard again"
        )
        exit(1)
    else:
        print(f"Found sink {new_sink.index}")

    # Move all the sink inputs to the new output
    # No longer needed as of PulseAudio 14
    if version.parse(pulse.server_info().server_version) < version.parse("14.0"):
        for sink_input in pulse.sink_input_list():
            print(f"Moving sink input {sink_input.index} to sink {new_sink.index}")
            try:
                pulse.sink_input_move(sink_input.index, new_sink.index)
            except:
                print(
                    f"Could not move sink input {sink_input.name} to {new_sink.index}"
                )

    # Set default device
    if new_sink == default_sink:
        print("Skipping default set")
    else:
        print("Setting default sink")
        pulse.default_set(new_sink)
    send_notification(f"Set default pulse device to {new_sink.description}")


def setup():
    # Show a list of sinks and ask the user to specify
    idx = 1
    for sink in pulse.sink_list():
        print(f"{idx}: {sink.description}")
        idx += 1
    headphones_id = int(input("Select the audio device to use as headphones > "))
    speakers_id = int(input("Select the audio device to use as speakers > "))
    if headphones_id == speakers_id:
        print("You cannot use the same device as both headphones and speakers")
        exit(1)
    if headphones_id > idx or headphones_id < 1:
        print("Invalid headphone output provided")
        exit(1)
    if speakers_id > idx or speakers_id < 1:
        print("Invalid speaker output provided")
        exit(1)
    headphone_sink = pulse.sink_list()[headphones_id - 1]
    speakers_sink = pulse.sink_list()[speakers_id - 1]

    save_config(
        {"name": headphone_sink.name, "description": headphone_sink.description},
        {"name": speakers_sink.name, "description": speakers_sink.description},
    )
    print(
        f"Selected {headphone_sink.description} ({headphone_sink.name}) as headphones and {speakers_sink.description} ({speakers_sink.name}) as speakers"
    )
    exit(0)


def dump_config():
    print(f" ==[ Current Configuration ]==")
    print(f"Headphones: {HEADPHONES['description']} ({HEADPHONES['name']})")
    print(f"Speakers: {SPEAKERS['description']} ({SPEAKERS['name']})")


def set_default_mic():
    default_source = pulse.server_info().default_source_name
    print(f"The default source is {default_source}")

    name_to_source = {}
    args = []
    for source in pulse.source_list():
        if source.name.endswith("monitor"):
            continue
        name_to_source[source.description] = source.name
        desc = source.description
        if source.name == default_source:
            desc = f"{desc}*"
        args.append(desc)

    dev_name = dmenu_prompt(args, "Select a microphone to use")

    if dev_name is None:
        print(f"Nothing selected")
        exit(1)

    target_source_name = name_to_source.get(dev_name, None)
    if target_source_name is None:
        print(f"Target source {dev_name} was not found!")
        exit(1)

    new_source = find_source(target_source_name, dev_name)

    if target_source_name == default_source:
        print("Skipping default set")
    else:
        print("Setting default source")
        pulse.default_set(new_source)
    send_notification(f"Set default pulse input device to {new_source.description}")


def dmenu_select():
    default_sink = pulse.server_info().default_sink_name
    name_to_sink = {}
    args = []
    for sink in pulse.sink_list():
        name_to_sink[sink.description] = sink.name
        desc = sink.description
        if default_sink == sink.name:
            desc = f"{desc}*"
        args.append(desc)
    args.append("Change Default Microphone")
    dev_name = dmenu_prompt(args, prompt="Select a device to switch to")
    if dev_name is None:
        print("Canceled selection")
        exit(0)
    if dev_name == "Change Default Microphone":
        set_default_mic()
        exit(0)
    alsa_name = name_to_sink.get(dev_name, None)
    if alsa_name is None:
        print(f"Could not find device {dev_name}")
        exit(1)
    print(f"Switching to {dev_name} ({alsa_name})")
    set_default({"name": alsa_name, "description": dev_name})


def main():
    load_config()

    parser = argparse.ArgumentParser(description="Sets default PulseAudio devices")
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "--headphones",
        "-p",
        action="store_true",
        help="Switch default device to headphones",
    )
    group.add_argument(
        "--speakers",
        "-s",
        action="store_true",
        help="Switch default device to speakers",
    )
    group.add_argument("--setup", action="store_true", help="Run setup wizard")
    group.add_argument(
        "--config", "-c", action="store_true", help="Show the current configuration"
    )
    group.add_argument(
        "--select", "-l", action="store_true", help="Use dmenu to select"
    )

    args = parser.parse_args()

    if args.headphones:
        set_default(HEADPHONES)
    elif args.speakers:
        set_default(SPEAKERS)
    elif args.setup:
        setup()
    elif args.config:
        dump_config()
    elif args.select:
        dmenu_select()
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
