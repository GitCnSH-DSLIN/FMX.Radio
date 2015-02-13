Unit FMX.Radio.BassAac;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ELSE}
  SysUtils,
  system.IOUtils,
{$ENDIF}
  FMX.Radio.Bass;
const
  // Additional BASS_SetConfig options
  BASS_CONFIG_MP4_VIDEO = $10700; // play the audio from MP4 videos
  BASS_CONFIG_AAC_MP4 = $10701; // support MP4 in BASS_AAC_StreamCreateXXX functions (no need for BASS_MP4_StreamCreateXXX)

  // Additional tags available from BASS_StreamGetTags
  BASS_TAG_MP4        = 7; // MP4/iTunes metadata

  BASS_AAC_STEREO = $400000; // downmatrix to stereo

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_AAC        = $10b00; // AAC
  BASS_CTYPE_STREAM_MP4        = $10b01; // MP4



var
BASS_AAC_StreamCreateFile: function (mem:BOOL; f:Pointer; offset,length:Cardinal; flags:Cardinal): HSTREAM; {$IFDEF MSWINDOWS}stdcall;{$ENDIF} {$IFNDEF MSWINDOWS} cdecl;{$ENDIF}
BASS_AAC_StreamCreateURL : function (URL:Pointer; offset:Cardinal; flags:Cardinal; proc:DOWNLOADPROC; user:Pointer): HSTREAM; {$IFDEF MSWINDOWS}stdcall;{$ENDIF} {$IFNDEF MSWINDOWS} cdecl;{$ENDIF}
BASS_AAC_StreamCreateFileUser : function (system,flags:Cardinal; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM; {$IFDEF MSWINDOWS}stdcall;{$ENDIF} {$IFNDEF MSWINDOWS} cdecl;{$ENDIF}
BASS_MP4_StreamCreateFile : function (mem:BOOL; f:Pointer; offset,length:QWORD; flags:Cardinal): HSTREAM; {$IFDEF MSWINDOWS}stdcall;{$ENDIF} {$IFNDEF MSWINDOWS} cdecl;{$ENDIF}
BASS_MP4_StreamCreateFileUser : function (system,flags:Cardinal; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM;{$IFDEF MSWINDOWS}stdcall;{$ENDIF} {$IFNDEF MSWINDOWS} cdecl;{$ENDIF}
szBassAccDLL : string;
FBassAccDLL : Cardinal;

procedure LoadDynamicBassAACDLL;
implementation


function BASSAAC_FOLDER: String;
begin
{$IFDEF MSWINDOWS}
  Result := '';
{$ELSE}
  Result := IncludeTrailingPathDelimiter(system.IOUtils.TPath.GetLibraryPath);
{$ENDIF}
end;


procedure LoadDynamicBassAACDLL;
begin
{$IFDEF MSWINDOWS}
  szBassAccDLL := 'bass_aac.dll';
{$ENDIF}
{$IFDEF LINUX}
  szBassAccDLL := 'libbass_aac.so';
{$ENDIF}
{$IFDEF MACOS}
{$IFDEF IOS}
  szBassAccDLL := 'libbass_aac.so';
{$ELSE}
  szBassAccDLL := 'libbass_aac.dylib';
{$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
  szBassAccDLL := 'libbass_aac.so';
{$ENDIF}

   FBassAccDLL := LoadLibrary(PChar(BASSAAC_FOLDER+szBassAccDLL));
   if FBassAccDLL<>0
    then begin
         @BASS_AAC_StreamCreateFile      := GetProcAddress(FBassAccDLL,'BASS_AAC_StreamCreateFile');
         @BASS_AAC_StreamCreateURL       := GetProcAddress(FBassAccDLL,'BASS_AAC_StreamCreateURL');
         @BASS_AAC_StreamCreateFileUser  := GetProcAddress(FBassAccDLL,'BASS_AAC_StreamCreateFileUser');
         @BASS_MP4_StreamCreateFile      := GetProcAddress(FBassAccDLL,'BASS_MP4_StreamCreateFile');
         @BASS_MP4_StreamCreateFileUser  := GetProcAddress(FBassAccDLL,'BASS_MP4_StreamCreateFileUser');
        end;
End;

initialization
LoadDynamicBassAACDLL;

finalization
FreeLibrary(FBassAccDLL);

end.
