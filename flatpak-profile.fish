function _flatpak_profile_complete
    set -l cmd (commandline -opc)
    if [ (count $cmd) -eq 1 ]
        for option in remove-profile new-profile choose-profile list-profiles
            echo $option
        end
    else
        switch $cmd[2]
            case "remove-profile" "choose-profile" "list-profiles"
                # Completion for flatpak apps
                if [ (count $cmd) -eq 2 ]
                    python -c "import os, os.path as path; print('\n'.join(os.listdir(path.join(path.expanduser('~'), '.local', 'share', 'flatpak', 'app'))))"
                else
                    set cmd_count (count $cmd)
                    if test $cmd_count -eq 3
                        if test $cmd[2] = "remove-profile"; or test $cmd[2] = "choose-profile"
                            # Completion for profiles using flatpak-profile list-profiles
                            flatpak-profile list-profiles $cmd[3] | string replace -r "\*" ""
                        end
                    end
                end
            case "new-profile"
                # First argument is app name, second is profile name.
                # Completion for flatpak apps
                if [ (count $cmd) -eq 2 ]
                    python -c "import os, os.path as path; print('\n'.join(os.listdir(path.join(path.expanduser('~'), '.local', 'share', 'flatpak', 'app'))))"
                else
                    # Placeholder for profile names as it's a new profile
                    echo ""
                end
        end
    end
end

complete -c flatpak-profile -f -a '(_flatpak_profile_complete)'
