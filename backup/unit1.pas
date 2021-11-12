unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MMSystem,
  LCLType, ExtCtrls, cmpKeyboard,u_info;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    lbl_Notenum: TLabel;
    lbl_note_val: TLabel;
    lbl_velocity: TLabel;
    lbl_vel_val: TLabel;
    txt_midimsg: TListBox;
    MidiKeys1: TMidiKeys;
    ScrollBar1: TScrollBar;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MidiKeys1NoteOff(Sender: TObject; note, velocity: Integer);
    procedure MidiKeys1NoteOn(Sender: TObject; note, velocity: Integer);
    procedure ScrollBar1Change(Sender: TObject);
  private

  public

  end;
  function MIDIEncodeMessage(Msg, Param1, Param2: integer): integer;
  procedure SetCurrentInstrument(instrument:integer);
  procedure NoteOn(NewNote, NewIntensity: byte);
  procedure NoteOff(NewNote, NewIntensity: byte);
  procedure TurnOffAllMidiNotes;
var
  frm_main: Tfrm_main;
  MidiOutDev: HMIDIOUT;
  m_velocity: integer=80;
  const
  MIDI_NOTE_ON = $90;
  MIDI_NOTE_OFF = $80;
  MIDI_CHANGE_INSTRUMENT = $C0;
  MIDI_DEVICE = 0;

implementation

{$R *.lfm}

{ Tfrm_main }

procedure Tfrm_main.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     midiOutClose(MidiOutDev);
end;

procedure Tfrm_main.ComboBox1Change(Sender: TObject);
begin
  SetCurrentInstrument(ComboBox1.ItemIndex);
end;

procedure Tfrm_main.Button1Click(Sender: TObject);
begin
  frm_info.Show;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
var
  i: integer;
begin
       midiOutOpen(@MidiOutDev,MIDI_MAPPER,frm_main.Handle,0,CALLBACK_WINDOW);
       frm_main.KeyPreview:= true;

end;

procedure Tfrm_main.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
      if(key=VK_ESCAPE) then frm_main.Close;
      if(key=VK_A) then MidiKeys1.PressNote(48,m_velocity,true);
      if(key=VK_W) then MidiKeys1.PressNote(49,m_velocity,true);
      if(key=VK_S) then MidiKeys1.PressNote(50,m_velocity,true);
      if(key=VK_E) then MidiKeys1.PressNote(51,m_velocity,true);
      if(key=VK_D) then MidiKeys1.PressNote(52,m_velocity,true);
      if(key=VK_f) then MidiKeys1.PressNote(53,m_velocity,true);
      if(key=VK_t) then MidiKeys1.PressNote(54,m_velocity,true);
      if(key=VK_g) then MidiKeys1.PressNote(55,m_velocity,true);
      if(key=VK_z) then MidiKeys1.PressNote(56,m_velocity,true);
      if(key=VK_h) then MidiKeys1.PressNote(57,m_velocity,true);
      if(key=VK_u) then MidiKeys1.PressNote(58,m_velocity,true);
      if(key=VK_j) then MidiKeys1.PressNote(59,m_velocity,true);
      if(key=VK_k) then MidiKeys1.PressNote(60,m_velocity,true);
      if(key=VK_o) then MidiKeys1.PressNote(61,m_velocity,true);
      if(key=VK_l) then MidiKeys1.PressNote(62,m_velocity,true);
      if(key=VK_p) then MidiKeys1.PressNote(63,m_velocity,true);



end;

procedure Tfrm_main.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

      if(key=VK_A) then MidiKeys1.ReleaseNote(48,m_velocity,true);
      if(key=VK_W) then MidiKeys1.ReleaseNote(49,m_velocity,true);
      if(key=VK_S) then MidiKeys1.ReleaseNote(50,m_velocity,true);
      if(key=VK_E) then MidiKeys1.ReleaseNote(51,m_velocity,true);
      if(key=VK_D) then MidiKeys1.ReleaseNote(52,m_velocity,true);
      if(key=VK_f) then MidiKeys1.ReleaseNote(53,m_velocity,true);
      if(key=VK_t) then MidiKeys1.ReleaseNote(54,m_velocity,true);
      if(key=VK_g) then MidiKeys1.ReleaseNote(55,m_velocity,true);
      if(key=VK_z) then MidiKeys1.ReleaseNote(56,m_velocity,true);
      if(key=VK_h) then MidiKeys1.ReleaseNote(57,m_velocity,true);
      if(key=VK_u) then MidiKeys1.ReleaseNote(58,m_velocity,true);
      if(key=VK_j) then MidiKeys1.ReleaseNote(59,m_velocity,true);
      if(key=VK_k) then MidiKeys1.ReleaseNote(60,m_velocity,true);
      if(key=VK_o) then MidiKeys1.ReleaseNote(61,m_velocity,true);
      if(key=VK_l) then MidiKeys1.ReleaseNote(62,m_velocity,true);
      if(key=VK_p) then MidiKeys1.ReleaseNote(63,m_velocity,true);

end;

procedure Tfrm_main.MidiKeys1NoteOff(Sender: TObject; note, velocity: Integer);
begin
     NoteOff(note,m_velocity);
end;

procedure Tfrm_main.MidiKeys1NoteOn(Sender: TObject; note, velocity: Integer);
begin
  lbl_note_val.Caption:=IntToStr(note);
  NoteOn(note,m_velocity);

end;

procedure Tfrm_main.ScrollBar1Change(Sender: TObject);
begin
  lbl_vel_val.Caption:=IntToStr(ScrollBar1.Position);
  m_velocity:=scrollbar1.Position;
end;

function MIDIEncodeMessage(Msg, Param1, Param2: integer): integer;
var
s : string;
begin
     s:=  IntToHex(Msg + (Param1 shl 8) + (Param2 shl 16),3);
     frm_main.txt_midimsg.Items.Add(s);

     result := Msg + (Param1 shl 8) + (Param2 shl 16);
end;

procedure SetCurrentInstrument(instrument: integer);
begin
  midiOutShortMsg(MidiOutDev, MIDIEncodeMessage(MIDI_CHANGE_INSTRUMENT, instrument, 0));
end;

procedure NoteOn(NewNote, NewIntensity: byte);
begin
  midiOutShortMsg(MidiOutDev, MIDIEncodeMessage(MIDI_NOTE_ON, NewNote, NewIntensity));
end;

procedure NoteOff(NewNote, NewIntensity: byte);
begin
  midiOutShortMsg(MidiOutDev, MIDIEncodeMessage(MIDI_NOTE_OFF, NewNote, NewIntensity));
end;

procedure SetPlaybackVolume(PlaybackVolume: cardinal);
begin
  midiOutSetVolume(MidiOutDev, PlaybackVolume);
end;
procedure TurnOffAllMidiNotes;
begin
     //Reset the midi device
     midiOutReset(MidiOutDev);
end;
end.

