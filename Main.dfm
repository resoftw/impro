object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Image Processing'
  ClientHeight = 518
  ClientWidth = 1183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 518
    Align = alLeft
    TabOrder = 0
    object btnload: TButton
      Left = 8
      Top = 8
      Width = 137
      Height = 25
      Caption = 'LoadImage'
      TabOrder = 0
      OnClick = btnloadClick
    end
    object btnreset: TButton
      Left = 151
      Top = 8
      Width = 137
      Height = 25
      Caption = 'Reset'
      TabOrder = 1
      OnClick = btnresetClick
    end
    object btnbw: TButton
      Left = 8
      Top = 39
      Width = 137
      Height = 25
      Caption = 'To BW'
      TabOrder = 2
      OnClick = btnbwClick
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 70
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'Diamond (3x3)'
      Items.Strings = (
        'Diamond (3x3)')
    end
    object btndilate: TButton
      Left = 151
      Top = 68
      Width = 137
      Height = 25
      Caption = 'Dilate'
      TabOrder = 5
      OnClick = btndilateClick
    end
    object btnbinary: TButton
      Left = 151
      Top = 39
      Width = 137
      Height = 25
      Caption = 'To Binary'
      TabOrder = 3
      OnClick = btnbinaryClick
    end
    object btnsobel: TButton
      Left = 8
      Top = 126
      Width = 137
      Height = 25
      Caption = 'Sobel'
      TabOrder = 6
      OnClick = btnsobelClick
    end
    object btnfillholes: TButton
      Left = 151
      Top = 126
      Width = 137
      Height = 25
      Caption = 'Fill Holes'
      TabOrder = 7
      OnClick = btnfillholesClick
    end
    object btnprewitt: TButton
      Left = 8
      Top = 157
      Width = 137
      Height = 25
      Caption = 'Prewitt'
      TabOrder = 8
      OnClick = btnprewittClick
    end
    object btngausblur: TButton
      Left = 151
      Top = 157
      Width = 137
      Height = 25
      Caption = 'Gaussian Blur'
      TabOrder = 9
      OnClick = btngausblurClick
    end
  end
  object img: TImage32
    Left = 297
    Top = 0
    Width = 886
    Height = 518
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 97
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Diamond (3x3)'
    Items.Strings = (
      'Diamond (3x3)')
  end
  object btnerode: TButton
    Left = 151
    Top = 95
    Width = 137
    Height = 25
    Caption = 'Erode'
    TabOrder = 3
    OnClick = btnerodeClick
  end
  object opd: TOpenPictureDialog
    Left = 40
    Top = 480
  end
end
