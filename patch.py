import lldb
import subprocess

def runCommand(command):
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = p.communicate()
    return out, err

def getProcessList():
    out, err = runCommand("ps -A -o pid,command")
    out = out.splitlines()
    out = [x.split(None, 1) for x in out]
    out = [x for x in out if len(x) == 2]
    return out

def getProcessID(processName):
    processList = getProcessList()
    for process in processList:
        if processName in str(process[1]):
            return int(process[0])
    return 0

Finder = "/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder"
pid = getProcessID(Finder)

if pid == 0:
    print("Finder not launched.")
    exit(1)

print("Find finder process id:", pid)

debugger = lldb.SBDebugger.Create()

err = lldb.SBError()
target = debugger.CreateTarget(Finder, None, None, True, err)

info = lldb.SBAttachInfo()
info.SetProcessID(pid)

process = target.Attach(info, err)
print(process)

code = [
    b"\x00\x00\x80\x92", # mov x0, -1
    b"\xc0\x03\x5f\xd6", # ret
]
raw = b"".join(code)

# inject dylib
# process.LoadImage(lldb.SBFileSpec("debugHelper.dylib", False), lldb.SBError())

modules = target.modules

for module in modules:
    if "DesktopServicesPriv" in module.file.fullpath:
        print("Found module: ", module.file.fullpath)

        symbol = module.FindFunctions("TFileDescriptor::Open")[0].GetSymbol()
        name = symbol.GetName()
        saddr = symbol.GetStartAddress().GetLoadAddress(target)

        print("Symbol: ", name, hex(saddr))
        process.WriteMemory(saddr, raw, err)
        print(err)

#print(err)
