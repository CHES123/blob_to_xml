create or replace noneditionable procedure report_album is
  BBLOB blob;
  CCLOB clob;
  
  cursor cur1 is 
    select al.title album,t.name trackname, ar.name artist ,t.composer , g.name genre ,t.unitprice  
    from Track t
    join genre g  on g.genreid = t.genreid
    join album al on al.albumid = t.albumid
    join artist ar on ar.artistid = al.artistid;
  
  cursor cur2 is 
    select al.title album, ar.name artist , g.name genre , sum(t.unitprice) totalprice 
    from Track t
    join genre g  on g.genreid = t.genreid
    join album al on al.albumid = t.albumid
    join artist ar on ar.artistid = al.artistid
    group by al.title , ar.name  , g.name ;

  procedure SAVE_MODULE(DATA in out nocopy clob, RES in out nocopy blob) as
    L_DEST_OFFSET   integer;
    L_SOURCE_OFFSET integer;
    L_LANG_CONTEXT  integer;
    L_WARNING       integer;
    L_BLOB_CSID     integer;
  begin
    L_BLOB_CSID     := NLS_CHARSET_ID('UTF8');
    L_DEST_OFFSET   := 1;
    L_SOURCE_OFFSET := 1;
    L_LANG_CONTEXT  := dbms_lob.default_lang_ctx;
    L_WARNING       := dbms_lob.warn_inconvertible_char;
    dbms_lob.convertToBlob(dest_lob     => RES,
                           src_clob     => DATA,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => L_DEST_OFFSET,
                           src_offset   => L_SOURCE_OFFSET,
                           blob_csid    => L_BLOB_CSID,
                           lang_context => L_LANG_CONTEXT,
                           warning      => L_WARNING);
  end;

  procedure HEAD_XML is
    xml_head varchar(6500) := '<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Nz</Author>
  <LastAuthor>Nz</LastAuthor>
  <LastPrinted>2022-10-22T19:32:23Z</LastPrinted>
  <Created>2022-10-22T19:23:34Z</Created>
  <LastSaved>2022-10-22T19:23:34Z</LastSaved>
  <Version>16.00</Version>
 </DocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>14370</WindowHeight>
  <WindowWidth>23955</WindowWidth>
  <WindowTopX>32767</WindowTopX>
  <WindowTopY>90</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Segoe UI" x:CharSet="1" x:Family="Swiss" ss:Size="9"
    ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s26">
   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
   <Font ss:FontName="Segoe UI" x:CharSet="1" x:Family="Swiss" ss:Size="9"
    ss:Color="#000000" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s77">
   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
   <NumberFormat ss:Format="Fixed"/>
  </Style>
 </Styles>
 <Worksheet ss:Name="all_track">
  <Names>
   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=all_track!R1C1:R1C7"
    ss:Hidden="1"/>
   <NamedRange ss:Name="Print_Titles" ss:RefersTo="=all_track!R1"/>
  </Names>
  <Table ss:ExpandedColumnCount="7"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="41.25" ss:DefaultRowHeight="12">
   <Column ss:AutoFitWidth="0" ss:Width="29.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="232.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="222"/>
   <Column ss:AutoFitWidth="0" ss:Width="81"/>
   <Column ss:AutoFitWidth="0" ss:Width="261"/>
   <Column ss:AutoFitWidth="0" ss:Width="50.25"/>
   <Column ss:StyleID="s77" ss:AutoFitWidth="0" ss:Width="60"/>
   <Row ss:AutoFitHeight="0" ss:Height="46.5" ss:StyleID="s26">
    <Cell><Data ss:Type="String">№</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">ALBUM</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">TRACKNAME</Data><NamedCell
      ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">ARTIST</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">COMPOSER</Data><NamedCell
      ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">GENRE</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">UNITPRICE</Data><NamedCell
      ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Titles"/></Cell>
   </Row>';
  begin
    dbms_lob.writeappend(CClOB, length(xml_head), xml_head);
  end;
  
    procedure LIST1_XML (num in number, ALBUM in varchar2,TRACKNAME in varchar2 ,ARTIST in varchar2,COMPOSER in varchar2,GENRE in varchar2,UNITPRICE in varchar2) is
    xml_list1 varchar(6500) :=  
    '<Row>
    <Cell><Data ss:Type="Number">'||num||'</Data></Cell>
    <Cell><Data ss:Type="String">'||ALBUM||'</Data></Cell>
    <Cell><Data ss:Type="String">'||TRACKNAME||'</Data></Cell>
    <Cell><Data ss:Type="String">'||ARTIST||'</Data></Cell>
    <Cell><Data ss:Type="String">'||COMPOSER||'</Data></Cell>
    <Cell><Data ss:Type="String">'||GENRE||'</Data></Cell>
    <Cell><Data ss:Type="Number">'||UNITPRICE||'</Data></Cell>
   </Row>';
  begin
    dbms_lob.writeappend(CClOB, length(xml_list1), xml_list1);
  end;
  
  procedure HALF_XML is
    xml_half varchar(6500) := '</Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Layout x:Orientation="Landscape"/>
    <Header x:Margin="0.31496062992125984" x:Data="&amp;RСтраница  &amp;P из &amp;N"/>
    <Footer x:Margin="0.31496062992125984"/>
    <PageMargins x:Bottom="0.74803149606299213" x:Left="0.23622047244094491"
     x:Right="0.23622047244094491" x:Top="0.74803149606299213"/>
   </PageSetup>
   <FitToPage/>
   <Print>
    <FitHeight>0</FitHeight>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <Scale>80</Scale>
    <HorizontalResolution>600</HorizontalResolution>
    <VerticalResolution>0</VerticalResolution>
    <Gridlines/>
   </Print>
   <Selected/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>1</SplitHorizontal>
   <TopRowBottomPane>1</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>13</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <AutoFilter x:Range="R1C1:R1C7" xmlns="urn:schemas-microsoft-com:office:excel">
  </AutoFilter>
 </Worksheet>
 <Worksheet ss:Name="total_price">
  <Names>
   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=total_price!R1C1:R1C5"
    ss:Hidden="1"/>
   <NamedRange ss:Name="Print_Titles" ss:RefersTo="=total_price!R1"/>
  </Names>
  <Table ss:ExpandedColumnCount="5"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="41.25" ss:DefaultRowHeight="12">
   <Column ss:Width="27.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="216"/>
   <Column ss:AutoFitWidth="0" ss:Width="109.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="65.25"/>
   <Row ss:AutoFitHeight="0" ss:Height="48" ss:StyleID="s26">
    <Cell><Data ss:Type="String">№</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">ALBUM</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">ARTIST</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">GENRE</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell
      ss:Name="Print_Titles"/></Cell>
    <Cell><Data ss:Type="String">TOTALPRICE</Data><NamedCell
      ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Titles"/></Cell>
   </Row>';
  begin
    dbms_lob.writeappend(CClOB, length(xml_half), xml_half);
  end;
  
      procedure LIST2_XML (num in number, ALBUM in varchar2,ARTIST in varchar2,GENRE in varchar2,TOTALPRICE in varchar2) is
    xml_list2 varchar(6500) :=  
    '<Row>
    <Cell><Data ss:Type="Number">'||num||'</Data></Cell>
    <Cell><Data ss:Type="String">'||ALBUM||'</Data></Cell>
    <Cell><Data ss:Type="String">'||ARTIST||'</Data></Cell>
    <Cell><Data ss:Type="String">'||GENRE||'</Data></Cell>
    <Cell><Data ss:Type="Number">'||TOTALPRICE||'</Data></Cell>
   </Row>';
  begin
    dbms_lob.writeappend(CClOB, length(xml_list2), xml_list2);
  end;
  
      procedure TAIL_XML is
    xml_tail varchar(6500) := '</Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Layout x:Orientation="Landscape"/>
    <Header x:Margin="0.31496062992125984" x:Data="&amp;RСтраница  &amp;P из &amp;N"/>
    <Footer x:Margin="0.31496062992125984"/>
    <PageMargins x:Bottom="0.74803149606299213" x:Left="0.23622047244094491"
     x:Right="0.23622047244094491" x:Top="0.74803149606299213"/>
   </PageSetup>
   <FitToPage/>
   <Print>
    <FitHeight>0</FitHeight>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>600</HorizontalResolution>
    <VerticalResolution>0</VerticalResolution>
    <Gridlines/>
   </Print>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>1</SplitHorizontal>
   <TopRowBottomPane>1</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <AutoFilter x:Range="R1C1:R1C5" xmlns="urn:schemas-microsoft-com:office:excel">
  </AutoFilter>
 </Worksheet>
</Workbook>';
  begin
    dbms_lob.writeappend(CClOB, length(xml_tail), xml_tail);
  end;
  

begin

  dbms_lob.createtemporary(CCLOB, true, dbms_lob.call);
  HEAD_XML;
  
  for r in cur1  loop
    LIST1_XML(
    num => cur1%rowcount,
    ALBUM => r.album,   
    TRACKNAME => r.trackname,
    ARTIST => r.artist,
    COMPOSER => r.composer,
    GENRE => r.genre,
    UNITPRICE => r.unitprice
    ); 
  end loop;
  
  HALF_XML;
  
  for r in cur2 loop
    LIST2_XML(
    num => cur2%rowcount,
    ALBUM => r.album, 
    ARTIST => r.artist,
    GENRE => r.genre,
    TOTALPRICE => r.TOTALPRICE
    ); 
  end loop;  
  
  TAIL_XML; 
  
  dbms_lob.createtemporary(BBLOB, true);
  save_module(CCLOB, BBLOB);
  DELETE FROM file_buf;
  insert into file_buf (bdata) values (BBLOB);

  dbms_lob.freetemporary(CCLOB);
  dbms_lob.freetemporary(BBLOB);
end report_album;
/
