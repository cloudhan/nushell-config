# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`
export-env {
    let starship_path = (if $env.OS? == "Windows_NT" { "C:/Program Files/starship/bin/starship.exe" } else { "starship" })
    load-env {
        STARSHIP_CONFIG: $"($nu.config-path | path dirname)/config-starship.toml"
        STARSHIP_SHELL: "nu"
        STARSHIP_SESSION_KEY: (random chars -l 16)
        PROMPT_MULTILINE_INDICATOR: (
            ^$'($starship_path)' prompt --continuation
        )

        # Does not play well with default character module.
        # TODO: Also Use starship vi mode indicators?
        PROMPT_INDICATOR: ""

        PROMPT_COMMAND: {||
            # jobs are not supported
            (
                ^$'($starship_path)' prompt
                    --cmd-duration $env.CMD_DURATION_MS
                    $"--status=($env.LAST_EXIT_CODE)"
                    --terminal-width (term size).columns
            )
        }

        config: ($env.config? | default {} | merge {
            render_right_prompt_on_last_line: true
        })

        PROMPT_COMMAND_RIGHT: {||
            (
                ^$'($starship_path)' prompt
                    --right
                    --cmd-duration $env.CMD_DURATION_MS
                    $"--status=($env.LAST_EXIT_CODE)"
                    --terminal-width (term size).columns
            )
        }
    }
}
