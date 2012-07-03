# MBCommon

MBCommon is a lightweight, generic Cocoa library for iOS and OS X. It is designed by [Mobiata][Mobiata] to be a repository for common code that can be shared across all of Mobiata's [open source projects][projects]. However, it can definitely be used on its own as it defines a number of classes and categories that are useful in their own right.

## Requirements

MBCommon runs on iOS 4.0 and above and OS X 10.6 and above.

## Usage

To include MBCommon in your application, clone the MBCommon repository and include all of the MBCommon source files in your project.

    $ git clone git://github.com/mobiata/MBCommon.git

To reference any of the functionality defined in MBCommon, simply `#import "MBCommon.h"` at the top of your source file.

## ARC Support

MBCommon does not currently support [ARC (Automatic Reference Counting)][ARC]. This may change in the future. For now, if you are using ARC in your own projects, you will need to set the `-fno-objc-arc` compiler flag on all MBCommon files. To do this:

1. Launch Xcode for your project.
2. Navigate to the "Builds Phases" tab of your target(s).
3. Find all MBCommon source files and add `-fno-objc-arc` to the "Compiler Flags" column.

## JSON Support

MBCommon defines a couple of methods in `MBJSON.h` that allow MBCommon (and other Mobiata projects) to easily encode and decode [JSON][JSON] strings. These methods should work without configuration and will automatically use whichever JSON library you have included in your project. Or, if your project targets OS X 10.7 (Lion) or iOS 5, you don't need to include any library as [`NSJSONSerialization`](NSJSONSerialization) can be used. The currently supported JSON libraries are:

* [JSONKit][JSONKit]
* [SBJson][SBJson]

## Localization

MBCommon defines a few strings that could theoretically be shown to users. These are most often error messages placed into the `userInfo` dictionary of `NSError` objects. MBCommon uses the `MBLocalizedString` macro to try and find translated versions of these strings for your users. This macro gives you a couple of choices if you decide to localize your application for languages other than English. `MBLocalizedString` is defined as follows:

```objc
#ifdef MBLocalizationTable
#define MBLocalizedString(key, default) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(default) table:MBLocalizationTable]
#else
#define MBLocalizedString(key, default) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(default) table:nil]
#endif
```

The first parameter of this macro is the string key while the second is the default (English) translation.

This macro allows you to add MBCommon strings directly to your standard `Localizable.strings` file. Or, if you wish, you can put all MBCommon strings into their own `.strings` file. If you opt for the latter, you must define `MBLocalizationTable` to be the name of this file. For example, if you want to use a file called `MBCommon.strings`, you would add the following to the `Prefix.pch` file of your project:

```objc
#define MBLocalizationTable @"MBCommon"
```

You can look for all strings used by MBCommon by searching for references to `MBLocalizedString` in this project. You should see a number of hits like the following:

```objc
NSString *msg = MBLocalizedString(@"cannot_encode_json_data", @"Unable to encode JSON data.");
```

[mobiata]: http://www.mobiata.com/
[projects]: https://github.com/mobiata/
[ARC]: http://clang.llvm.org/docs/AutomaticReferenceCounting.html
[NSJSONSerialization]: http://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html
[JSONKit]: https://github.com/johnezang/JSONKit
[SBJson]: http://stig.github.com/json-framework/
[JSON]: http://json.org/
