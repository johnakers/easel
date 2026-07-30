package;

import easel.components.ChatBox;
import flixel.FlxG;
import sys.io.File;

class DebugChatBox {
    public static function dumpCoordinates(chatBox:ChatBox):Void {
        var log = "";
        log += "ChatBox Group X/Y: " + chatBox.x + ", " + chatBox.y + "\n";
        
        // Loop through all members
        for (member in chatBox.members) {
            if (member != null) {
                var clsName = Type.getClassName(Type.getClass(member));
                log += "Member (" + clsName + ") X/Y: " + member.x + ", " + member.y + "\n";
                if (Std.isOfType(member, flixel.group.FlxSpriteGroup)) {
                    var group:flixel.group.FlxSpriteGroup = cast member;
                    for (sub in group.members) {
                        if (sub != null) {
                            var subCls = Type.getClassName(Type.getClass(sub));
                            log += "  SubMember (" + subCls + ") X/Y: " + sub.x + ", " + sub.y + "\n";
                        }
                    }
                }
            }
        }
        File.saveContent("chatbox_debug.txt", log);
    }
}
