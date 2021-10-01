//proto freeimage.dll

#define OT4XB_ASSERT_ALL

#include "ot4xb.ch"
#include "G7FreeImage.ch"

#PRAGMA LIBRARY( "ot4xb.LIB" )
  
 // Init Error routines ----------------------------------------------------
//DLL_API void DLL_CALLCONV FreeImage_Initialise(BOOL load_local_plugins_only FI_DEFAULT(FALSE));
 DLL FreeImage IMPORT VOID FreeImage_Initialise( BOOL bLocalPOnly ) SYMBOL "_FreeImage_Initialise@4"

//DLL_API void DLL_CALLCONV FreeImage_DeInitialise(void);
  DLL FreeImage IMPORT VOID FreeImage_DeInitialize( ) SYMBOL  "_FreeImage_DeInitialise@0"

// Version routines ---------------------------------------------------------
//DLL_API const char *DLL_CALLCONV FreeImage_GetVersion(void);
  DLL FreeImage IMPORT ZSTRING  FreeImage_GetVersion() SYMBOL  "_FreeImage_GetVersion@0"

//DLL_API const char *DLL_CALLCONV FreeImage_GetCopyrightMessage(void);
  DLL FreeImage IMPORT ZSTRING FreeImage_GetCopyrightMessage()  SYMBOL  "_FreeImage_GetCopyrightMessage@0"

// Allocate / Clone / Unload routines ---------------------------------------
//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Allocate(int width, int height, int bpp, unsigned red_mask FI_DEFAULT(0), ;
 //unsigned green_mask FI_DEFAULT(0), unsigned blue_mask FI_DEFAULT(0));

  DLL FreeImage IMPORT  POINTER32 FreeImage_Allocate(INT nwidth, INT nheigth, INT nbpp, UINT cred_mask,;
                                               UINT cgreen_mask, UINT cblue_mask) SYMBOL "_FreeImage_Allocate@24"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_AllocateT(FREE_IMAGE_TYPE type, int width, int height, int bpp FI_DEFAULT(8), ;
//unsigned red_mask FI_DEFAULT(0), unsigned green_mask FI_DEFAULT(0), unsigned blue_mask FI_DEFAULT(0));


 DLL FreeImage IMPORT POINTER32 FreeImage_AllocateT(Int type,Int width, Int heigth, Int bpp, UINT red_mask,;
                UINT green_mask, UINT blue_mask ) SYMBOL "_FreeImage_AllocateT@28"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Clone(FIBITMAP *dib);
  DLL FreeImage IMPORT POINTER32 FreeImage_Clone(POINTER32 dib)  SYMBOL "_FreeImage_Clone@4"

//DLL_API void DLL_CALLCONV FreeImage_Unload(FIBITMAP *dib);
  DLL FreeImage IMPORT VOID FreeImage_Unload(POINTER32 dib) SYMBOL "_FreeImage_Unload@4"

// Load / Save routines -----------------------------------------------------
//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Load(FREE_IMAGE_FORMAT fif, const char *filename, int flags FI_DEFAULT(0));
  DLL FreeImage IMPORT POINTER32 FreeImage_Load(INT fit, LPSTR cFilename, INT cFlags) SYMBOL "_FreeImage_Load@12"

// DLL_API FIBITMAP *DLL_CALLCONV FreeImage_LoadFromHandle(FREE_IMAGE_FORMAT fif, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));  ///OJO  STRUCT
//   DLL FreeImage IMPORT POINTER32 FreeImage_LoadFromHandle(INT nFif, INT io, INT nhandle, INT nflags) SYMBOL  "_FreeImage_LoadFromHandle@16"

 //DLL_API BOOL DLL_CALLCONV FreeImage_Save(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, const char *filename, int flags FI_DEFAULT(0));
   DLL FreeImage IMPORT BOOL  FreeImage_Save(INT fit , POINTER32 dib, LPSTR cFilename, INT cFlags ) SYMBOL "_FreeImage_Save@16"

//DLL_API BOOL DLL_CALLCONV FreeImage_SaveToHandle(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));

 // Memory I/O stream routines -----------------------------------------------
//DLL_API FIMEMORY *DLL_CALLCONV FreeImage_OpenMemory(BYTE *data FI_DEFAULT(0), DWORD size_in_bytes FI_DEFAULT(0));
  DLL FreeImage IMPORT POINTER32 FreeImage_OpenMemory(LPBYTE data,DWORD nzise) SYMBOL "_FreeImage_OpenMemory@8"

//DLL_API void DLL_CALLCONV FreeImage_CloseMemory(FIMEMORY *stream);
 DLL FreeImage IMPORT VOID FreeImage_CloseMemory(POINTER32  nstream) SYMBOL "_FreeImage_CloseMemory@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_LoadFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0));
 DLL FreeImage IMPORT POINTER32 FreeImage_LoadFromMemory(INT nfif,POINTER32 nstream, int flags) SYMBOL "_FreeImage_LoadFromMemory@12"

//DLL_API BOOL DLL_CALLCONV FreeImage_SaveToMemory(FREE_IMAGE_FORMAT fif, FIBITMAP *dib, FIMEMORY *stream, int flags FI_DEFAULT(0));
  DLL FreeImage IMPORT BOOL FreeImage_SaveToMemory(INT nfif,POINTER32 ndib, POINTER32 nstream, int flags) SYMBOL "_FreeImage_SaveToMemory@16"

//DLL_API long DLL_CALLCONV FreeImage_TellMemory(FIMEMORY *stream);
  DLL FreeImage IMPORT LONG FreeImage_TellMemory(POINTER32 nstream) SYMBOL " _FreeImage_TellMemory@4"

//DLL_API BOOL DLL_CALLCONV FreeImage_SeekMemory(FIMEMORY *stream, long offset, int origin);
   DLL FreeImage IMPORT BOOL FreeImage_SeekMemory(POINTER32 nstream,LONG offset, INT flags) SYMBOL "_FreeImage_SeekMemory@12"

//DLL_API BOOL DLL_CALLCONV FreeImage_AcquireMemory(FIMEMORY *stream, BYTE **data, DWORD *size_in_bytes);
   DLL FreeImage IMPORT BOOL FreeImage_AcquireMemory(POINTER32 nstream, LPBYTE data, DWORD nzise ) SYMBOL " _FreeImage_AcquireMemory@12"

//DLL_API unsigned DLL_CALLCONV FreeImage_ReadMemory(void *buffer, unsigned size, unsigned count, FIMEMORY *stream);
 DLL FreeImage IMPORT UINT FreeImage_ReadMemory(VOID buffer, uint size, uint count, POINTER32 nstram) SYMBOL "_FreeImage_ReadMemory@16"

//DLL_API unsigned DLL_CALLCONV FreeImage_WriteMemory(const void *buffer, unsigned size, unsigned count, FIMEMORY *stream);

  DLL FreeImage IMPORT UINT FreeImage_WriteMemory( lpvoid buffer, uint size,uint count, int flags, POINTER32 nstream) SYMBOL "_FreeImage_WriteMemory@16"

//DLL_API FIMULTIBITMAP *DLL_CALLCONV FreeImage_LoadMultiBitmapFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0));
 DLL FreeImage IMPORT POINTER32 FreeImage_LoadMultiBitmapFromMemory(INT nfif,POINTER32 nstream, int flags) SYMBOL "_FreeImage_LoadMultiBitmapFromMemory@12"

// Plugin Interface ---------------------------------------------------------

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_RegisterLocalPlugin(FI_InitProc proc_address, const char *format FI_DEFAULT(0),;
// const char *description FI_DEFAULT(0), const char *extension FI_DEFAULT(0), const char *regexpr FI_DEFAULT(0));

 // DLL FreeImage IMPORT INT FreeImage_RegisterLocalPlugin(INT nproc_address , LPSTR cformat,;                //ojo missing
 //                     LPSTR cdescripcion,LPSTR cextension, LPSTR cregexpr) SYMBOL "_FreeImage_RegisterLocalPlugin@20"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_RegisterExternalPlugin(const char *path, const char *format FI_DEFAULT(0),;
// const char *description FI_DEFAULT(0), const char *extension FI_DEFAULT(0), const char *regexpr FI_DEFAULT(0));
   DLL FreeImage IMPORT INT FreeImage_RegisterExternalPlugin(LPSTR cpath, LPSTR cformat,;
                      LPSTR cdescripcion,LPSTR cextension, LPSTR cregexpr) SYMBOL "_FreeImage_RegisterExternalPlugin@20"

//DLL_API int DLL_CALLCONV FreeImage_GetFIFCount(void);
  DLL FreeImage IMPORT INT FreeImage_GetFIFCount() SYMBOL "_FreeImage_GetFIFCount@0"

//DLL_API int DLL_CALLCONV FreeImage_SetPluginEnabled(FREE_IMAGE_FORMAT fif, BOOL enable);
  DLL FreeImage IMPORT INT FreeImage_SetPluginEnabled(INT nformat,BOOL lenabled) SYMBOL "_FreeImage_SetPluginEnabled@8"

//DLL_API int DLL_CALLCONV FreeImage_IsPluginEnabled(FREE_IMAGE_FORMAT fif);
  DLL FreeImage IMPORT INT FreeImage_IsPluginEnabled(INT nformat) SYMBOL "_FreeImage_IsPluginEnabled@4"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFIFFromFormat(const char *format);
   DLL FreeImage IMPORT INT FreeImage_GetFIFFromFormat(LPSTR cfilename) SYMBOL "_FreeImage_GetFIFFromFormat@4"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFIFFromMime(const char *mime);
    DLL FreeImage IMPORT INT FreeImage_GetFIFFromMime(LPSTR cmine) SYMBOL "_FreeImage_GetFIFFromMime@4"

//DLL_API const char *DLL_CALLCONV FreeImage_GetFormatFromFIF(FREE_IMAGE_FORMAT fif);
  DLL FreeImage IMPORT ZSTRING FreeImage_GetFormatFromFIF(INT nformat) SYMBOL "_FreeImage_GetFormatFromFIF@4"

//DLL_API const char *DLL_CALLCONV FreeImage_GetFIFExtensionList(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT ZSTRING FreeImage_GetFIFExtensionList(INT nformat) SYMBOL "_FreeImage_GetFIFExtensionList@4"

//DLL_API const char *DLL_CALLCONV FreeImage_GetFIFDescription(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT ZSTRING FreeImage_GetFIFDescription(INT nformat) SYMBOL "_FreeImage_GetFIFDescription@4"

//DLL_API const char *DLL_CALLCONV FreeImage_GetFIFRegExpr(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT ZSTRING FreeImage_GetFIFRegExpr(INT nformat) SYMBOL "_FreeImage_GetFIFRegExpr@4"

//DLL_API const char *DLL_CALLCONV FreeImage_GetFIFMimeType(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT ZSTRING FreeImage_GetFIFMimeType(INT nformat) SYMBOL "_FreeImage_GetFIFMimeType@4"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFIFFromFilename(const char *filename);
  DLL FreeImage IMPORT INT FreeImage_GetFIFFromFilename(LPSTR cfilename) SYMBOL "_FreeImage_GetFIFFromFilename@4"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFIFFromFilenameU(const wchar_t *filename);    //ojo


//DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsReading(FREE_IMAGE_FORMAT fif);
  DLL FreeImage IMPORT BOOL FreeImage_FIFSupportsReading(INT nformat) SYMBOL "_FreeImage_FIFSupportsReading@4"

//DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsWriting(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT BOOL FreeImage_FIFSupportsWriting(INT nformat) SYMBOL "_FreeImage_FIFSupportsWriting@4"

//DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsExportBPP(FREE_IMAGE_FORMAT fif, int bpp);
 DLL FreeImage IMPORT BOOL FreeImage_FIFSupportsExportBPP(INT nformat,  INT nbpp) SYMBOL "_FreeImage_FIFSupportsExportBPP@8"

//DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsExportType(FREE_IMAGE_FORMAT fif, FREE_IMAGE_TYPE type);
 DLL FreeImage IMPORT BOOL FreeImage_FIFSupportsExportType(INT nformat,  INT nftype) SYMBOL "_FreeImage_FIFSupportsExportType@8"

//DLL_API BOOL DLL_CALLCONV FreeImage_FIFSupportsICCProfiles(FREE_IMAGE_FORMAT fif);
 DLL FreeImage IMPORT BOOL FreeImage_FIFSupportsICCProfiles(INT nformat,  INT nftype) SYMBOL "_FreeImage_FIFSupportsICCProfiles@4"

// Multipaging interface ----------------------------------------------------

//DLL_API FIMULTIBITMAP * DLL_CALLCONV FreeImage_OpenMultiBitmap(FREE_IMAGE_FORMAT fif, const char *filename,;
//  BOOL create_new, BOOL read_only, BOOL keep_cache_in_memory FI_DEFAULT(FALSE), int flags FI_DEFAULT(0));

  DLL FreeImage IMPORT POINTER32  FreeImage_OpenMultiBitmap( INT nformat,LPSTR cfilename, BOOL lcreatenew,;
                 BOOL lreadonly, BOOL lkeepcache) SYMBOL "_FreeImage_OpenMultiBitmap@24"

//DLL_API BOOL DLL_CALLCONV FreeImage_CloseMultiBitmap(FIMULTIBITMAP *bitmap, int flags FI_DEFAULT(0));
  DLL FreeImage IMPORT BOOL  FreeImage_CloseMultiBitmap( POINTER32 cBitmap, INT cFlags) SYMBOL "_FreeImage_CloseMultiBitmap@8"

//DLL_API int DLL_CALLCONV FreeImage_GetPageCount(FIMULTIBITMAP *bitmap);
  DLL FreeImage IMPORT INT  FreeImage_GetPageCount(POINTER32 cBitmap) SYMBOL  "_FreeImage_GetPageCount@4"

//DLL_API void DLL_CALLCONV FreeImage_AppendPage(FIMULTIBITMAP *bitmap, FIBITMAP *data);
  DLL FreeImage IMPORT VOID  FreeImage_AppendPage( POINTER32 cBitmap, POINTER32 cdata) SYMBOL   "_FreeImage_AppendPage@8"

//DLL_API void DLL_CALLCONV FreeImage_InsertPage(FIMULTIBITMAP *bitmap, int page, FIBITMAP *data);
 DLL FreeImage IMPORT VOID  FreeImage_InsertPage(POINTER32 cBitmap,INT npage, POINTER32 cdata) SYMBOL "_FreeImage_InsertPage@12"

//DLL_API void DLL_CALLCONV FreeImage_DeletePage(FIMULTIBITMAP *bitmap, int page);
 DLL FreeImage IMPORT VOID  FreeImage_DeletePage(POINTER32 cBitmap,INT npage) SYMBOL  "_FreeImage_DeletePage@8"

//DLL_API FIBITMAP * DLL_CALLCONV FreeImage_LockPage(FIMULTIBITMAP *bitmap, int page);
 DLL FreeImage IMPORT UINT  FreeImage_LockPage( POINTER32 cBitmap,INT npage) SYMBOL  "_FreeImage_LockPage@8"

//DLL_API void DLL_CALLCONV FreeImage_UnlockPage(FIMULTIBITMAP *bitmap, FIBITMAP *data, BOOL changed);
 DLL FreeImage IMPORT VOID  FreeImage_UnlockPage(POINTER32 cBitmap,POINTER32 ndata, BOOL lchanged) SYMBOL  "_FreeImage_UnlockPage@12"

//DLL_API BOOL DLL_CALLCONV FreeImage_MovePage(FIMULTIBITMAP *bitmap, int target, int source);
 DLL FreeImage IMPORT BOOL  FreeImage_MovePage( POINTER32 cBitmap,INT ntarget,INT nsource) SYMBOL  "_FreeImage_MovePage@12"

//DLL_API BOOL DLL_CALLCONV FreeImage_GetLockedPageNumbers(FIMULTIBITMAP *bitmap, int *pages, int *count);   //OJO
 DLL FreeImage IMPORT BOOL FreeImage_GetLockedPageNumbers( POINTER32 cBitmap, LPINT8 npages, LPINT8 ncount ) SYMBOL  "_FreeImage_GetLockedPageNumbers@12"

 // Filetype request routines ------------------------------------------------

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileType(const char *filename, int size FI_DEFAULT(0));
  DLL FreeImage IMPORT INT FreeImage_GetFileType(LPSTR cfilename, Int nSize) SYMBOL "_FreeImage_GetFileType@8"

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileTypeFromHandle(FreeImageIO *io, fi_handle handle, int size FI_DEFAULT(0)); //OJO

//DLL_API FREE_IMAGE_FORMAT DLL_CALLCONV FreeImage_GetFileTypeFromMemory(FIMEMORY *stream, int size FI_DEFAULT(0));
  DLL FreeImage IMPORT INT FreeImage_GetFileTypeMemory(POINTER32 nstream, Int nSize) SYMBOL "_FreeImage_GetFileTypeFromMemory@8"

// Image type request routine -----------------------------------------------

//DLL_API FREE_IMAGE_TYPE DLL_CALLCONV FreeImage_GetImageType(FIBITMAP *dib);

  DLL FreeImage IMPORT INT FreeImage_GetImageType(POINTER32 ndib) SYMBOL "_FreeImage_GetImageType@4"

   // FreeImage helper routines ------------------------------------------------

//DLL_API BOOL DLL_CALLCONV FreeImage_IsLittleEndian(void);
   DLL FreeImage IMPORT BOOL FreeImage_IsLittleEndian() SYMBOL "_FreeImage_IsLittleEndian@0"

//DLL_API BOOL DLL_CALLCONV FreeImage_LookupX11Color(const char *szColor, BYTE *nRed, BYTE *nGreen, BYTE *nBlue);
    DLL FreeImage IMPORT BOOL FreeImage_LookupX11Color(LPSTR szColor, LPBYTE nRed, LPBYTE nGreen, LPBYTE nBlue) SYMBOL "_FreeImage_LookupX11Color@16"

//DLL_API BOOL DLL_CALLCONV FreeImage_LookupSVGColor(const char *szColor, BYTE *nRed, BYTE *nGreen, BYTE *nBlue);
  DLL FreeImage IMPORT BOOL FreeImage_LookupSVGColor(LPSTR szColor, LPBYTE nRed, LPBYTE nGreen, LPBYTE nBlue ) SYMBOL "_FreeImage_LookupSVGColor@16"

// Pixel access routines ----------------------------------------------------
//   DLL_API BOOL DLL_CALLCONV FreeImage_FlipHorizontal(FIBITMAP *dib);
     DLL FreeImage IMPORT BOOL FreeImage_FlipHorizontal(Pointer32 nDib) SYMBOL "_FreeImage_FlipHorizontal@4"

//  DLL_API BOOL DLL_CALLCONV FreeImage_FlipVertical(FIBITMAP *dib);
    DLL FreeImage IMPORT BOOL FreeImage_FlipVertical(Pointer32 nDib) SYMBOL "_FreeImage_FlipVertical@4"

 //DLL_API BOOL DLL_CALLCONV FreeImage_Invert(FIBITMAP *dib);
    DLL FreeImage IMPORT BOOL FreeImage_Invert(Pointer32 nDib) SYMBOL "_FreeImage_Invert@4"

  //DLL_API FIBITMAP *DLL_CALLCONV FreeImage_GetChannel(FIBITMAP *dib, FREE_IMAGE_COLOR_CHANNEL channel);
   DLL FreeImage IMPORT Pointer32 FreeImage_GetChannel(Pointer32 nDib, Int  nChannel) SYMBOL "_FreeImage_GetChannel@8"

   //DLL_API BOOL DLL_CALLCONV FreeImage_AdjustCurve(FIBITMAP *dib, BYTE *LUT, FREE_IMAGE_COLOR_CHANNEL channel);
    DLL FreeImage IMPORT BOOL FreeImage_AdjustCurve(Pointer32 ndib, lpBYTE nLut, Int nChannel) SYMBOL "_FreeImage_AdjustCurve@12"

  // DLL_API BOOL DLL_CALLCONV FreeImage_AdjustGamma(FIBITMAP *dib, double gamma);
     DLL FreeImage IMPORT BOOL FreeImage_AdjustGamma(Pointer32 ndib, double gamma) SYMBOL "_FreeImage_AdjustGamma@12"

  //DLL_API BOOL DLL_CALLCONV FreeImage_AdjustBrightness(FIBITMAP *dib, double percentage);
     DLL FreeImage IMPORT BOOL FreeImage_AdjustBrightness(Pointer32 ndib, double percentage) SYMBOL "_FreeImage_AdjustBrightness@12"

   //DLL_API BOOL DLL_CALLCONV FreeImage_AdjustContrast(FIBITMAP *dib, double percentage);
     DLL FreeImage IMPORT BOOL FreeImage_AdjustContrast(Pointer32 ndib, double percentage) SYMBOL "_FreeImage_AdjustContrast@12"

    //DLL_API FIBITMAP * DLL_CALLCONV FreeImage_Rescale(FIBITMAP *dib, int dst_width, int dst_height, FREE_IMAGE_FILTER filter);
      DLL FreeImage IMPORT Pointer32 FreeImage_Rescale(Pointer32 ndib, int dst_width, int dst_height, int nfilter) SYMBOL "_FreeImage_Rescale@16"
                    
    //DLL_API FIBITMAP * DLL_CALLCONV FreeImage_RescaleRect(FIBITMAP *dib, int dst_width, int dst_height, int left, int top, int right, int bottom, FREE_IMAGE_FILTER filter FI_DEFAULT(FILTER_CATMULLROM), unsigned flags FI_DEFAULT(0));
    //DLL FreeImage IMPORT Pointer32 FreeImage_RescaleRect(Pointer32 ndib, int dst_width, int dst_height, int left, int top, int right, int bottom, int nfilter) SYMBOL "_FreeImage_RescaleRect@16"
    //NON Mi funziona o comunque non fa quello che mi aspetto


  //DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Copy(FIBITMAP *dib, int left, int top, int right, int bottom);
   DLL FreeImage IMPORT Pointer32 FreeImage_Copy(Pointer32 nDib, int left, int top, int right, int bottom)  SYMBOL "_FreeImage_Copy@20"

  //DLL_API BOOL DLL_CALLCONV FreeImage_Paste(FIBITMAP *dst, FIBITMAP *src, int left, int top, int alpha);
   DLL FreeImage IMPORT BOOL FreeImage_Paste(Pointer32 nDst , Pointer32 nSrc, int left, int top, int alpha  ) SYMBOL "_FreeImage_Paste@20"

 //DLL_API FIBITMAP *DLL_CALLCONV FreeImage_RotateClassic(FIBITMAP *dib, double angle)
    DLL FreeImage IMPORT Pointer32 FreeImage_RotateClassic(Pointer32 nDib, double nAngle) SYMBOL "_FreeImage_RotateClassic@12"

//  DLL_API FIBITMAP *DLL_CALLCONV FreeImage_RotateEx(FIBITMAP *dib, double angle, double x_shift, double y_shift, double x_origin, double y_origin, BOOL use_mask);
    DLL FreeImage IMPORT Pointer32 FreeImage_RotateEx(Pointer32 nDib, double nAngle,double x_shift, double y_shift, double x_origin, ;
          double y_origin, BOOL use_mask) SYMBOL "_FreeImage_RotateEx@48"

//DLL_API BYTE *DLL_CALLCONV FreeImage_GetBits(FIBITMAP *dib);
  DLL FreeImage IMPORT LPBYTE FreeImage_GetBits(POINTER32 ndib) SYMBOL "_FreeImage_GetBits@4"

//DLL_API BYTE *DLL_CALLCONV FreeImage_GetScanLine(FIBITMAP *dib, int scanline);
   DLL FreeImage IMPORT LPBYTE FreeImage_GetScanLinee(POINTER32 ndib,int scanline) SYMBOL "_FreeImage_GetScanLine@8"

//DLL_API BOOL DLL_CALLCONV FreeImage_GetPixelIndex(FIBITMAP *dib, unsigned x, unsigned y, BYTE *value);
  DLL FreeImage IMPORT BOOL FreeImage_GetPixelIndex(POINTER32 ndib,uint x, uint y, LPBYTE value) SYMBOL "_FreeImage_GetPixelIndex@16"

//DLL_API BOOL DLL_CALLCONV FreeImage_GetPixelColor(FIBITMAP *dib, unsigned x, unsigned y, RGBQUAD *value);
   DLL FreeImage IMPORT BOOL FreeImage_GetPixelColor(POINTER32 ndib,uint x, uint y, POINTER32 value) SYMBOL "_FreeImage_GetPixelColor@16"

//DLL_API BOOL DLL_CALLCONV FreeImage_SetPixelIndex(FIBITMAP *dib, unsigned x, unsigned y, BYTE *value);
  DLL FreeImage IMPORT BOOL FreeImage_SetPixelIndex(POINTER32 ndib, uint x, uint y, LPBYTE value) SYMBOL "_FreeImage_SetPixelIndex@16"

//DLL_API BOOL DLL_CALLCONV FreeImage_SetPixelColor(FIBITMAP *dib, unsigned x, unsigned y, RGBQUAD *value);
  DLL FreeImage IMPORT BOOL FreeImage_SetPixelColor(POINTER32 ndib, uint x, uint y, Pointer32 value) SYMBOL "_FreeImage_SetPixelColor@16"

// DIB info routines --------------------------------------------------------

 //DLL_API unsigned DLL_CALLCONV FreeImage_GetColorsUsed(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetColorsUsed(POINTER32 ndib) SYMBOL "_FreeImage_GetColorsUsed@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetBPP(FIBITMAP *dib);
    DLL FreeImage IMPORT UINT FreeImage_GetBPP(POINTER32 ndib) SYMBOL "_FreeImage_GetBPP@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetWidth(FIBITMAP *dib);
  DLL FreeImage IMPORT UINT FreeImage_GetWidth(POINTER32 ndib) SYMBOL "_FreeImage_GetWidth@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetHeight(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetHeight(POINTER32 ndib) SYMBOL "_FreeImage_GetHeight@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetLine(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetLine(POINTER32 ndib) SYMBOL "_FreeImage_GetLine@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetDIBSize(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetDIBSize(POINTER32 ndib) SYMBOL "_FreeImage_GetDIBSize@4"

//DLL_API RGBQUAD *DLL_CALLCONV FreeImage_GetPalette(FIBITMAP *dib);
 // DLL FreeImage IMPORT POINTER32  FreeImage_GetPalette(POINTER32 ndib) SYMBOL "_FreeImage_GetPalette@4"

Function FreeImage_GetPalette( ndib ) //
local QTEMPLATE qt AS  POINTER32 PARAM AS POINTER32
local pt := FpQCall( {"freeimage","_FreeImage_GetPalette@4"},qt,ndib )
if pt != 0
   return RGBCUAD():New():_link_(pt,.F.)
end
return NIL

  // DLL_API unsigned DLL_CALLCONV FreeImage_GetPitch(FIBITMAP *dib);
    DLL FreeImage IMPORT UINT FreeImage_GetPitch(POINTER32 ndib) SYMBOL "_FreeImage_GetPitch@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetDotsPerMeterX(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetDotsPerMeterX(POINTER32 ndib) SYMBOL "_FreeImage_GetDotsPerMeterX@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetDotsPerMeterY(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetDotsPerMeterY(POINTER32 ndib) SYMBOL "_FreeImage_GetDotsPerMeterY@4"

//DLL_API void DLL_CALLCONV FreeImage_SetDotsPerMeterX(FIBITMAP *dib, unsigned res);
   DLL FreeImage IMPORT VOID FreeImage_SetDotsPerMeterX(POINTER32 ndib, uint res) SYMBOL "_FreeImage_SetDotsPerMeterX@8"

//DLL_API void DLL_CALLCONV FreeImage_SetDotsPerMeterY(FIBITMAP *dib, unsigned res);
   DLL FreeImage IMPORT VOID FreeImage_SetDotsPerMeterY(POINTER32 ndib, uint res) SYMBOL "_FreeImage_SetDotsPerMeterY@8"

//DLL_API BITMAPINFOHEADER *DLL_CALLCONV FreeImage_GetInfoHeader(FIBITMAP *dib);
  // DLL FreeImage IMPORT POINTER32 FreeImage_GetInfoHeader(POINTER32 ndib) SYMBOL "_FreeImage_GetInfoHeader@4"

Function FreeImage_GetInfoHeader( ndib ) //
local QTEMPLATE qt AS  POINTER32 PARAM AS POINTER32
local pt := FpQCall( {"freeimage","_FreeImage_GetInfoHeader@4"},qt,ndib )
if pt != 0
   return BITMAPINFOHEADER():New():_link_(pt,.F.)
end
return NIL

//DLL_API BITMAPINFO *DLL_CALLCONV FreeImage_GetInfo(FIBITMAP *dib);
//   DLL FreeImage IMPORT POINTER32 FreeImage_GetInfo(POINTER32 ndib) SYMBOL "_FreeImage_GetInfo@4"

 Function FreeImage_GetInfo( ndib ) // oField
local QTEMPLATE qt AS  POINTER32 PARAM AS POINTER32
local pt := FpQCall( {"freeimage","_FreeImage_GetInfo@4"},qt,ndib )
if pt != 0
   return BITMAPINFO():New():_link_(pt,.F.)
end
return NIL

//DLL_API FREE_IMAGE_COLOR_TYPE DLL_CALLCONV FreeImage_GetColorType(FIBITMAP *dib);
   DLL FreeImage IMPORT INT FreeImage_GetColorType(POINTER32 ndib) SYMBOL "_FreeImage_GetColorType@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetRedMask(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetRedMask(POINTER32 ndib) SYMBOL "_FreeImage_GetRedMask@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetGreenMask(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetGreenMask(POINTER32 ndib) SYMBOL "_FreeImage_GetGreenMask@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetBlueMask(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetBlueMask(POINTER32 ndib) SYMBOL "_FreeImage_GetBlueMask@4"

//DLL_API unsigned DLL_CALLCONV FreeImage_GetTransparencyCount(FIBITMAP *dib);
   DLL FreeImage IMPORT UINT FreeImage_GetTransparencyCount(POINTER32 ndib) SYMBOL "_FreeImage_GetTransparencyCount@4"

//DLL_API BYTE * DLL_CALLCONV FreeImage_GetTransparencyTable(FIBITMAP *dib);
   DLL FreeImage IMPORT LPBYTE FreeImage_GetTransparencyTable(POINTER32 ndib) SYMBOL "_FreeImage_GetTransparencyTable@4"

//DLL_API void DLL_CALLCONV FreeImage_SetTransparent(FIBITMAP *dib, BOOL enabled);
   DLL FreeImage IMPORT VOID FreeImage_SetTransparent(POINTER32 ndib, bool lenabled) SYMBOL "_FreeImage_SetTransparent@8"

//DLL_API void DLL_CALLCONV FreeImage_SetTransparencyTable(FIBITMAP *dib, BYTE *table, int count);
   DLL FreeImage IMPORT VOID FreeImage_SetTransparencyTable(POINTER32 ndib, LPBYTE table, int count) SYMBOL "_FreeImage_SetTransparencyTable@12"

//DLL_API BOOL DLL_CALLCONV FreeImage_IsTransparent(FIBITMAP *dib);
   DLL FreeImage IMPORT BOOL FreeImage_IsTransparent(POINTER32 ndib) SYMBOL "_FreeImage_IsTransparent@4"

//DLL_API BOOL DLL_CALLCONV FreeImage_HasBackgroundColor(FIBITMAP *dib);
   DLL FreeImage IMPORT BOOL FreeImage_HasBackgroundColor(POINTER32 ndib) SYMBOL "_FreeImage_HasBackgroundColor@4"

//DLL_API BOOL DLL_CALLCONV FreeImage_GetBackgroundColor(FIBITMAP *dib, RGBQUAD *bkcolor);
  DLL FreeImage IMPORT BOOL FreeImage_GetBackgroundColor(POINTER32 ndib, POINTER32 bkcolor) SYMBOL "_FreeImage_GetBackgroundColor@8"

//DLL_API BOOL DLL_CALLCONV FreeImage_SetBackgroundColor(FIBITMAP *dib, RGBQUAD *bkcolor);
  DLL FreeImage IMPORT BOOL FreeImage_SetBackgroundColor(POINTER32 ndib, POINTER32 bkcolor) SYMBOL "_FreeImage_SetBackgroundColor@8"

 // Smart conversion routines ------------------------------------------------

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo4Bits(FIBITMAP *dib);
   DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo4Bits(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo4Bits@4 "

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo8Bits(FIBITMAP *dib);
    DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo8Bits(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo8Bits@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToGreyscale(FIBITMAP *dib);
    DLL FreeImage IMPORT POINTER32 FreeImage_ConvertToGreyscale(POINTER32 ndib) SYMBOL "_FreeImage_ConvertToGreyscale@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo16Bits555(FIBITMAP *dib);
   DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo16Bits555(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo16Bits555@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo16Bits565(FIBITMAP *dib);
     DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo16Bits565(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo16Bits565@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo24Bits(FIBITMAP *dib);
    DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo24Bits(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo24Bits@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertTo32Bits(FIBITMAP *dib);
     DLL FreeImage IMPORT POINTER32 FreeImage_ConvertTo32Bits(POINTER32 ndib) SYMBOL "_FreeImage_ConvertTo32Bits@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ColorQuantize(FIBITMAP *dib, FREE_IMAGE_QUANTIZE quantize);
     DLL FreeImage IMPORT POINTER32 FreeImage_ColorQuantize(POINTER32 ndib,int quantize) SYMBOL "_FreeImage_ColorQuantize@8"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ColorQuantizeEx(FIBITMAP *dib, FREE_IMAGE_QUANTIZE quantize FI_DEFAULT(FIQ_WUQUANT),;
// int PaletteSize FI_DEFAULT(256), int ReserveSize FI_DEFAULT(0), RGBQUAD *ReservePalette FI_DEFAULT(NULL));
      DLL FreeImage IMPORT POINTER32 FreeImage_ColorQuantizeEx(POINTER32 ndib,int quantize, int Palettesize,;      //ojo
          int reservezie, POINTER32 rgbReserved ) SYMBOL "_FreeImage_ColorQuantizeEx@20"                                                 //ojo

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Threshold(FIBITMAP *dib, BYTE T);
      DLL FreeImage IMPORT POINTER32 FreeImage_Threshold(POINTER32 ndib, byte t) SYMBOL "_FreeImage_Threshold@8"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_Dither(FIBITMAP *dib, FREE_IMAGE_DITHER algorithm);
     DLL FreeImage IMPORT POINTER32 FreeImage_Dither(POINTER32 ndib, int algorithm) SYMBOL "_FreeImage_Dither@8"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertFromRawBits(BYTE *bits, int width, int height, int pitch, unsigned bpp, ;
//unsigned red_mask, unsigned green_mask, unsigned blue_mask, BOOL topdown FI_DEFAULT(FALSE));
    DLL FreeImage IMPORT POINTER32 FreeImage_ConvertFromRawBits(LPBYTE bits, int width, int height, int pitch, uint bpp,;
      uint red_mask, uint green_mask, uint blue_mask, bool topdown) SYMBOL "_FreeImage_ConvertToRawBits@32"

//DLL_API void DLL_CALLCONV FreeImage_ConvertToRawBits(BYTE *bits, FIBITMAP *dib, int pitch, unsigned bpp, ;
 //unsigned red_mask, unsigned green_mask, unsigned blue_mask, BOOL topdown FI_DEFAULT(FALSE));

    DLL FreeImage IMPORT VOID FreeImage_ConvertToRawBits(LPBYTE bits,POINTER32 ndib, int pitch, uint bpp, ;
          uint red_mask, uint green_mask, uint blue_mask, bool topdown ) SYMBOL "_FreeImage_ConvertToRawBits@32"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToRGBF(FIBITMAP *dib);
      DLL FreeImage IMPORT POINTER32 FreeImage_ConverToRGBF(POINTER32 ndib) SYMBOL "_FreeImage_ConvertToRGBF@4"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToStandardType(FIBITMAP *src, BOOL scale_linear FI_DEFAULT(TRUE));
      DLL FreeImage IMPORT POINTER32 FreeImage_ConvertToStandardType(POINTER32 src,bool scale_linear) SYMBOL "_FreeImage_ConvertToStandardType@8"

//DLL_API FIBITMAP *DLL_CALLCONV FreeImage_ConvertToType(FIBITMAP *src, FREE_IMAGE_TYPE dst_type, BOOL scale_linear FI_DEFAULT(TRUE));
    DLL FreeImage IMPORT POINTER32 FreeImage_ConvertToType(POINTER32 src,int dst_type, bool scale_linear) SYMBOL "_FreeImage_ConvertToType@12"

  BEGIN STRUCTURE BITMAPINFOHEADER
  MEMBER  DWORD biSize
  MEMBER  LONG  biWidth
  MEMBER  LONG  biHeight
  MEMBER  WORD  biPlanes
  MEMBER  WORD  biBitCount
  MEMBER  DWORD biCompression
  MEMBER  DWORD biSizeImage
  MEMBER  LONG  biXPelsPerMeter
  MEMBER  LONG  biYPelsPerMeter
  MEMBER  DWORD biClrUsed
  MEMBER  DWORD biClrImportant
 END STRUCTURE

 BEGIN STRUCTURE BITMAPINFO
  MEMBER @ BITMAPINFOHEADER bmiHeader
  MEMBER DWORD _bmiColors_
  DYNAMIC READONLY PROPERTY pBmiColors BLOCK {|s| s:_addressof_( "_bmiColors_" ) }
 END STRUCTURE

/*
BEGIN STRUCTURE BITMAPINFO
  MEMBER @ BITMAPINFOHEADER bmiHeader
  MEMBER DWORD _bmiColors_
END STRUCTURE
 */

 BEGIN STRUCTURE  FIMEMORY
 MEMBER POINTER32 data
 END STRUCTURE

 BEGIN STRUCTURE  FIBIMAP
 MEMBER POINTER32 data
 END STRUCTURE

 BEGIN STRUCTURE  FIMULTIBIMAP
 MEMBER POINTER32 data
 END STRUCTURE

 BEGIN STRUCTURE RGBCUAD
 MEMBER  BYTE rgbBlue
 MEMBER  BYTE rgbGreen
 MEMBER  BYTE rgbRed
 MEMBER  BYTE rgbReserved

 END STRUCTURE

