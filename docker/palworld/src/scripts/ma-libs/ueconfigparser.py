import collections
import configparser
import re
import uuid

class UuidDict(collections.OrderedDict):

    def __setitem__(self, key, value):
        modkey = key
        if key in self and isinstance(value, list):
            modkey = key + "{{" + uuid.uuid4().hex + "}}"
        super().__setitem__(modkey, value)

class ConfigParser(configparser.ConfigParser):
    __pattern = re.compile(r"({{[a-zA-Z\d]{32}}})$")

    # def __init__(self, defaults=None, dict_type=_default_dict,
    #              allow_no_value=False, *, delimiters=('=', ':'),
    #              comment_prefixes=('#', ';'), inline_comment_prefixes=None,
    #              strict=True, empty_lines_in_values=True,
    #              default_section=DEFAULTSECT,
    #              interpolation=_UNSET, converters=_UNSET):

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('dict_type', UuidDict)
        kwargs.setdefault('strict', False)
        kwargs.setdefault('empty_lines_in_values', False)
        super().__init__(*args, **kwargs)
        self.optionxform = str

    def set(self, section, option, value=None):
        key = option
        if (option in self._sections[section].items()):
            key = key + "{{" + uuid.uuid4().hex + "}}"
        super().set(section, key, value)

    def _strip_unique_uid(self, value):
        match = self.__pattern.search(value)
        if (match is not None):
            return value[:-36]
        return value
    
    def write(self, fp, space_around_delimiters=False):
        """Write an .ini-format representation of the configuration state.

        If `space_around_delimiters` is True, delimiters
        between keys and values are surrounded by spaces.

        Please note that comments in the original configuration file are not
        preserved when writing the configuration back.
        """
        super().write( fp, space_around_delimiters)

    def _write_section(self, fp, section_name, section_items, delimiter):
        """Write a single section to the specified `fp`."""
        fp.write("[{}]\n".format(section_name))
        for key, value in section_items:
            option = self._strip_unique_uid(key)
            value = self._interpolation.before_write(self, section_name, option,
                                                     value)
            if value is not None or not self._allow_no_value:
                value = delimiter + str(value).replace('\n', '\n\t')
            else:
                value = ""
            fp.write("{}{}\n".format(option, value))
        fp.write("\n")