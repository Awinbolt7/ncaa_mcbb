class file_handler(object):
    import os
    def check_create_file_dir(self, dir):
        try:
            if not self.os.path.isdir(dir):
                self.os.makedirs(dir)
        except Exception as e:
            print(e)
            return False


class colors (object):
    #color output, yay!
    from colorama import Fore, Back
    success_color = Fore.GREEN
    light_success_color = Fore.LIGHTGREEN_EX
    neutral_color = Fore.LIGHTYELLOW_EX
    wait_color = Fore.BLUE
    light_fail_color = Fore.LIGHTRED_EX
    fail_color = Fore.RED
    logging_color = Fore.LIGHTBLUE_EX
    info_color = Fore.WHITE
    normal_bk_ft_color = Fore.WHITE + Back.BLACK