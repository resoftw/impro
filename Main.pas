unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ExtDlgs, Vcl.StdCtrls,jpeg,GR32,System.generics.collections,pngimage,
  GR32_Image,GR32_Resamplers;

type

  TStructureElement = class
  private
    bits:pByteArray;
    function GetPixel(X, Y: Integer): byte;
    procedure SetPixel(X, Y: Integer; const Value: byte);
  public
    w:integer;
    h:integer;
    cx,cy:integer;
    constructor Create(aw,ah,xc,yc:integer);
    destructor Destroy;
    property  Pixel[X, Y: Integer]: byte read GetPixel write SetPixel;
  end;

  TDiamondStrel = class (TStructureElement)
  public
    constructor Create(n:integer);
  end;

  TIntMatrix3x3 = array[0..2,0..2]of integer;

  TFMain = class(TForm)
    Panel1: TPanel;
    btnload: TButton;
    opd: TOpenPictureDialog;
    img: TImage32;
    btnreset: TButton;
    btnbw: TButton;
    ComboBox1: TComboBox;
    btndilate: TButton;
    btnbinary: TButton;
    btnsobel: TButton;
    ComboBox2: TComboBox;
    btnerode: TButton;
    btnfillholes: TButton;
    btnprewitt: TButton;
    btngausblur: TButton;
    btnmedian: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnloadClick(Sender: TObject);
    procedure btnbwClick(Sender: TObject);
    procedure btnresetClick(Sender: TObject);
    procedure btnbinaryClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btndilateClick(Sender: TObject);
    procedure btnsobelClick(Sender: TObject);
    procedure btnerodeClick(Sender: TObject);
    procedure btnfillholesClick(Sender: TObject);
    procedure btnprewittClick(Sender: TObject);
    procedure btngausblurClick(Sender: TObject);
    procedure btnmedianClick(Sender: TObject);
  private
    { Private declarations }
    pic:TBitmap32;
    prd:TBitmap32;
    procedure PlotImage(b:TBitmap32);
    procedure RevertImage;
    procedure ResizeImage;
    function DiscreteConvultion3(mask:TIntMatrix3x3;mu,di,o:double):TBitmap32;
    procedure Median(ww,wh:integer);
//    function getstrel(n:integer):
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

function colormatch(a:TColor32;b:integer):boolean;
function bw(c:Integer):TColor32;


implementation

{$R *.dfm}

procedure TFMain.btnloadClick(Sender: TObject);
begin
  if opd.Execute then begin
    pic.LoadFromFile(opd.Filename);
    ResizeImage;
    RevertImage;
  end;
end;


procedure TFMain.btnmedianClick(Sender: TObject);
begin
  Median(3,3);
  PlotImage(prd);
end;

procedure TFMain.btnprewittClick(Sender: TObject);
var mask:TIntMAtrix3x3;
    b1,b2:TBitmap32;
    x,y:integer;
begin
  mask[0,0]:=-1;mask[0,1]:=-1;mask[0,2]:=-1;
  mask[1,0]:=0;mask[1,1]:=0;mask[1,2]:=0;
  mask[2,0]:=1;mask[2,1]:=1;mask[2,2]:=1;
  b1:=DiscreteConvultion3(mask,1,1,0.5);
  mask[0,0]:=-1;mask[0,1]:=-0;mask[0,2]:=1;
  mask[1,0]:=-1;mask[1,1]:=0;mask[1,2]:=1;
  mask[2,0]:=-1;mask[2,1]:=0;mask[2,2]:=1;
  b2:=DiscreteConvultion3(mask,1,1,0.5);
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var c1:TColor32;
      var p1:=PColor32Entry(@c1);
      var c2:TColor32;
      var p2:=PColor32Entry(@c2);
      c1:=b1.Pixel[x,y];
      c2:=b2.Pixel[x,y];
      prd.Pixel[x,y]:=bw(abs(p1.R+p2.R));
    end;
  end;
  PlotImage(prd);
end;

procedure TFMain.RevertImage;
begin
  prd.Assign(pic);
  PlotImage(prd);
end;

procedure TFMain.btnresetClick(Sender: TObject);
begin
  revertimage;
end;

procedure TFMain.btnsobelClick(Sender: TObject);
  function ce(d:double):byte;
  begin
    if d<0 then d:=0;
    if d>255 then d:=255;
//    if d>127 then d:=255 else d:=0;
    result:=round(d);
  end;
var mask:TIntMAtrix3x3;
    b1,b2:TBitmap32;
    x,y:integer;
begin
//  mask[0,0]:=1;mask[0,1]:=1;mask[0,2]:=1;
//  mask[1,0]:=1;mask[1,1]:=1;mask[1,2]:=1;
//  mask[2,0]:=1;mask[2,1]:=1;mask[2,2]:=1;
//  var b0:=DiscreteConvultion3(mask,1,9,0);
//  prd.Assign(b0);
  mask[0,0]:=-1;mask[0,1]:=-2;mask[0,2]:=-1;
  mask[1,0]:=0;mask[1,1]:=0;mask[1,2]:=0;
  mask[2,0]:=1;mask[2,1]:=2;mask[2,2]:=1;
  b1:=DiscreteConvultion3(mask,1,1,0.5);
  mask[0,0]:=-1;mask[0,1]:=-0;mask[0,2]:=1;
  mask[1,0]:=-2;mask[1,1]:=0;mask[1,2]:=2;
  mask[2,0]:=-1;mask[2,1]:=0;mask[2,2]:=1;
  b2:=DiscreteConvultion3(mask,1,1,0.5);
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var c1:TColor32;
      var p1:=PColor32Entry(@c1);
      var c2:TColor32;
      var p2:=PColor32Entry(@c2);
      c1:=b1.Pixel[x,y];
      c2:=b2.Pixel[x,y];
      p1.R:=ce(p1.R+p2.R);
      p1.G:=ce(p1.G+p2.G);
      p1.B:=ce(p1.B+p2.B);
      prd.Pixel[x,y]:=c1//bw(abs(p1.R+p2.R));
    end;
  end;
  PlotImage(prd);
end;

function TFMain.DiscreteConvultion3(mask: TIntMatrix3x3;mu,di,o:double):TBitmap32;
  function ce(d:double):byte;
  begin
    if d<0 then d:=0;
    if d>255 then d:=255;
//    if d>127 then d:=255 else d:=0;
    result:=round(d);
  end;
var
    i,j,m,n,idx,jdx:integer;
    ms,im:integer;
    vr,vg,vb:double;
    b:TBitmap32;
begin
  b:=TBitmap32.Create;
  b.SetSizeFrom(prd);
  b.Clear;
  for i:=0 to prd.Height-1 do begin
    for j:=0 to prd.Width-1 do begin
      vr:=0;
      vb:=0;
      vg:=0;
      var col:TColor32;
      var pcol:PColor32Entry:=PColor32Entry(@col);
      for m:=-1 to 1 do begin
        for n:=-1 to 1 do begin
          ms:=mask[m+1,n+1];
          idx:=i+m;
          jdx:=j+n;
          col:=prd.PixelS[jdx,idx];
          vr:=vr+ms*pcol.R+o;
          vg:=vg+ms*pcol.G+o;
          vb:=vb+ms*pcol.B+o;
        end;
      end;
      vr:=vr*mu/di;
      vg:=vg*mu/di;
      vb:=vb*mu/di;
      pcol.R:=ce(vr);
      pcol.G:=ce(vg);
      pcol.B:=ce(vb);
      b.PixelS[j,i]:=col;
    end;
  end;
  result:=b;
end;

procedure TFMain.btnbwClick(Sender: TObject);
var x,y:integer;
begin
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var c:=prd.Pixel[x,y];
      var p:PColor32Entry:=PColor32Entry(@c);
      var r:real:=p.R*0.2126+p.G*0.7152+p.B*0.0722;
      p.R:=round(r);
      p.G:=round(r);
      p.B:=round(r);
      prd.Pixel[x,y]:=c;
    end;
  end;
  PlotImage(prd);
//  let lum = .2126 * red + .7152 * green + .0722 * blue
end;

procedure TFMain.btndilateClick(Sender: TObject);
var se:TDiamondStrel;
    b:TBitmap32;
    x,y,r,c:integer;
begin
  b:=TBitmap32.Create;
  b.SetSizeFrom(prd);
  b.Clear;
  se:=TDiamondStrel.Create(5);
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var smax:=0;
      var px:TColor32;
      var pp:PColor32Entry:=PColor32Entry(@px);
      for r:=-se.cy to se.h-se.cy-1 do begin
        for c:=-se.cx to se.w-se.cx-1 do begin
           if se.Pixel[c+se.cx,r+se.cy]=1 then begin
             px:=prd.PixelS[x+c,y+r];
             if pp.R>smax then smax:=pp.R;
           end;
        end;
      end;
      b.Pixel[x,y]:=bw(smax);
    end;
  end;
  PlotImage(b);
  prd.Assign(b);
  se.Free;
  b.Free;
  PlotImage(prd);
end;

procedure TFMain.btnerodeClick(Sender: TObject);
var se:TDiamondStrel;
    b:TBitmap32;
    x,y,r,c:integer;
begin
  b:=TBitmap32.Create;
  b.SetSizeFrom(prd);
  b.Clear;
  se:=TDiamondStrel.Create(5);
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var smax:=255;
      var px:TColor32;
      var pp:PColor32Entry:=PColor32Entry(@px);
      for r:=-se.cy to se.h-se.cy-1 do begin
        for c:=-se.cx to se.w-se.cx-1 do begin
           if se.Pixel[c+se.cx,r+se.cy]=1 then begin
             px:=prd.PixelS[x+c,y+r];
             if pp.R<smax then smax:=pp.R;
           end;
        end;
      end;
      pp.R:=smax;
      pp.G:=smax;
      pp.B:=smax;
      b.Pixel[x,y]:=px;
    end;
  end;
  PlotImage(b);
  prd.Assign(b);
  se.Free;
  b.Free;
  PlotImage(prd);
end;

function colormatch(a:TColor32;b:integer):boolean;
var p:PColor32Entry;
begin
  p:=PColor32Entry(@a);
  result:= p.R=b;
end;

function bw(c:Integer):TColor32;
begin
  result:=Color32(c,c,c);
end;


procedure FloodFill(var p:TBitmap32;pt:TPoint;t,c:Integer);
var q:TQueue<TPoint>;
begin
  q:=TQueue<TPoint>.create;
  q.Enqueue(pt);
  while q.Count>0 do begin
    var n:TPoint:=q.Dequeue;
    if not colormatch(p.PixelS[n.X,n.Y],t) then continue;
    var w:TPoint:=n;
    var e:TPoint:=Point(n.X+1,n.Y);
    while (w.X>=0) and colormatch(p.PixelS[w.X,w.Y],t) do begin
      p.PixelS[w.X,w.Y]:=bw(c);
      if (w.Y>0) and colormatch(p.PixelS[w.X,w.Y-1],t) then q.Enqueue(Point(w.X,w.Y-1));
      if (w.Y<p.Height-1)and colormatch(p.PixelS[w.X,w.Y+1],t) then q.Enqueue(Point(w.X,w.Y+1));
      dec(w.X);
    end;
    while (e.X<p.Width-1) and colormatch(p.PixelS[e.X,e.Y],t) do begin
      p.PixelS[e.X,e.Y]:=bw(c);
      if (e.Y>0)and colormatch(p.PixelS[e.X,e.Y-1],t) then q.Enqueue(Point(e.X,e.Y-1));
      if (e.Y<p.Height-1) and colormatch(p.PixelS[e.X,e.Y+1],t) then q.Enqueue(Point(e.X,e.Y+1));
      inc(e.X);
    end;
  end;
end;

procedure TFMain.btnfillholesClick(Sender: TObject);
var
    b:TBitmap32;
    x,y:integer;
    pt:TPoint;
begin
  b:=TBitmap32.Create;
  b.Assign(prd);
  pt:=Point(-1,-1);
  for y:=0 to b.Height-1 do begin
    for x:=0 to b.Width-1 do begin
      if colormatch(b.Pixel[x,y],0) then begin
        pt:=Point(x,y);
        break;
      end;
      if (pt.X<>-1) and (pt.Y<>-1) then break;
    end;
  end;
  FloodFill(b,pt,0,128);
  for y:=0 to b.Height-1 do begin
    for x:=0 to b.Width-1 do begin
      if not colormatch(b.Pixel[x,y],128) then begin
        prd.Pixel[x,y]:=bw(255);
      end;
    end;
  end;
  b.Free;
  PlotImage(prd);
end;


procedure TFMain.btngausblurClick(Sender: TObject);
var mask:TIntMAtrix3x3;
begin
  mask[0,0]:=1;mask[0,1]:=1;mask[0,2]:=1;
  mask[1,0]:=1;mask[1,1]:=1;mask[1,2]:=1;
  mask[2,0]:=1;mask[2,1]:=1;mask[2,2]:=1;
  var b0:=DiscreteConvultion3(mask,1,9,0);
  prd.Assign(b0);
  plotimage(prd);
end;

procedure TFMain.btnbinaryClick(Sender: TObject);
var x,y:integer;
begin
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      var c:=prd.Pixel[x,y];
      var p:PColor32Entry:=PColor32Entry(@c);
      var r:integer:=0;
      if p.R>=128 then r:=255;
      p.R:=round(r);
      p.G:=round(r);
      p.B:=round(r);
      prd.Pixel[x,y]:=c;
    end;
  end;
  PlotImage(prd);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  pic:=TBitmap32.Create;
  prd:=TBitmap32.Create;
  img.Bitmap.SetSizeFrom(img);
  img.Bitmap.Clear($ffffffff);
end;

procedure TFMain.FormResize(Sender: TObject);
begin
  img.Bitmap.SetSizeFrom(img);
  if not prd.Empty then PlotImage(prd);
end;


procedure QuickSort(var A: array of byte; iLo, iHi: Integer) ;
var
  Lo, Hi, Pivot, T: Integer;
begin
  Lo := iLo;
  Hi := iHi;
  Pivot := A[(Lo + Hi) div 2];
  repeat
    while (A[Lo] < Pivot)and (lo<ihi) do Inc(Lo) ;
    while (A[Hi] > Pivot) and (hi>ilo) do Dec(Hi) ;
    if Lo <= Hi then
    begin
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo) ;
      Dec(Hi) ;
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSort(A, iLo, Hi) ;
  if Lo < iHi then QuickSort(A, Lo, iHi) ;
end;

procedure TFMain.Median(ww, wh: integer);
var ar:Array of byte;
    x,y,i,ex,ey,xx,yy:integer;
    wx,wy:integer;
    b:TBitmap32;
begin
  SetLength(ar,ww*wh);
  b:=TBitmap32.Create;
  b.SetSizeFrom(prd);
  b.Clear;
  ex:=ww div 2;
  ey:=wh div 2;
  for y:=0 to prd.Height-1 do begin
    for x:=0 to prd.Width-1 do begin
      i:=0;
      for wy:=0 to wh-1 do begin
        for wx:=0 to ww-1 do begin
          xx:=x+wx-ex;
          yy:=y+wy-ey;
          if (xx<0) or (xx>=prd.Width) then continue;
          if (yy<0) or (yy>=prd.Height) then continue;
          var cp:=prd.Pixel[xx,yy];
          var pc:=PColor32Entry(@cp);
          ar[i]:=pc.R;
          inc(i);
        end;
      end;
      QUickSort(ar,0,i-1);
      b.Pixel[x,y]:=bw(ar[i div 2]);
    end;
  end;
  prd.Assign(b);
  b.Free;
end;

procedure TFMain.ResizeImage;
var b:TBitmap32;
    nw,nh:integer;
    sc,scw,sch:real;
begin
  b:=TBitmap32.Create;
  b.Assign(pic);
  scw:=480/b.Width;
  sch:=480/b.Height;
  if scw>sch then sc:=sch else sc:=scw;
  nw:=round(b.Width*sc);
  nh:=round(b.Height*sc);
  pic.SetSize(nw,nh);
  b.Resampler:=TKernelResampler.Create;
  pic.Draw(Rect(0,0,nw,nh),Rect(0,0,b.Width,b.Height),b);
  b.Free;
end;

procedure TFMain.PlotImage(b: TBitmap32);
var x,y,w,h,nw,nh,tw,th:integer;
    sc,scw,sch:real;
begin
  w:=b.Width;
  h:=b.Height;
  tw:=img.Width-20;
  th:=img.Height-20;
  scw:=tw/w;
  sch:=th/h;
  if (scw>sch)then sc:=sch else sc:=scw;
  nw:=round(w*sc);
  nh:=round(h*sc);
  x:=img.Width div 2 - nw div 2;
  y:=img.Height div 2 - nh div 2;
  b.Resampler:=TKernelResampler.Create;
  img.Bitmap.Clear(clGray);
  img.Bitmap.Draw(Rect(x,y,x+nw,y+nh),Rect(0,0,w,h),b);
end;


{ TStructureElement }

constructor TStructureElement.Create(aw,ah,xc,yc:integer);
begin
  w:=aw;
  h:=ah;
  cx:=xc;
  cy:=yc;
  bits:=allocmem(w*h);
end;

destructor TStructureElement.Destroy;
begin
  freemem(bits);
end;

function TStructureElement.GetPixel(X, Y: Integer): byte;
begin
  if (x<0)or(x>=w) then result:=0
  else
  if (y<0)or(y>=h) then result:=0
  else
  result:=bits[y*w+x];
end;

procedure TStructureElement.SetPixel(X, Y: Integer; const Value: byte);
begin
  if (x<0)or(x>=w) then exit
  else
  if (y<0)or(y>=h) then exit
  else
  bits[y*w+x]:=value;
end;

{ TDiamondStrel }

constructor TDiamondStrel.Create(n:integer);
var x,y,c:integer;
begin
  inherited Create(n,n,n div 2,n div 2);
  c:=n div 2;
  for y:=0 to n-1 do begin
    for x:=0 to n-1 do begin
      var v:=abs(y-c)+abs(x-c);
      if (v<=c) then pixel[x,y]:=1 else pixel[x,y]:=0;
    end;
  end;
end;

end.
