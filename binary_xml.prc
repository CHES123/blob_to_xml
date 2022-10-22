create or replace noneditionable procedure binary_xml is
  BBLOB blob;
  CCLOB clob;

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

  procedure XML_1 is
    xml1 varchar(6500) := '<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Nz</Author>
  <LastAuthor>Nz</LastAuthor>
  <Created>2022-10-21T17:21:22Z</Created>
  <Version>16.00</Version>
 </DocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>12750</WindowHeight>
  <WindowWidth>27855</WindowWidth>
  <WindowTopX>32767</WindowTopX>
  <WindowTopY>32767</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:CharSet="204" x:Family="Swiss" ss:Size="11"
    ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
 </Styles>
 <Worksheet ss:Name="list1">
  <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="2" x:FullColumns="1"
   x:FullRows="1" ss:DefaultRowHeight="15">
   <Row>
    <Cell><Data ss:Type="Number">123</Data></Cell>
    <Cell><Data ss:Type="Number">123</Data></Cell>
    <Cell><Data ss:Type="Number">123</Data></Cell>
   </Row>
   <Row>
    <Cell><Data ss:Type="Number">456</Data></Cell>
    <Cell><Data ss:Type="Number">456</Data></Cell>
    <Cell><Data ss:Type="Number">456</Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>3</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
';
  begin
    dbms_lob.writeappend(CClOB, length(xml1), xml1);
  end;

begin

  dbms_lob.createtemporary(CCLOB, true, dbms_lob.call);
  XML_1;
  dbms_lob.createtemporary(BBLOB, true);
  save_module(CCLOB, BBLOB);
  DELETE FROM file_buf;
  insert into file_buf (bdata) values (BBLOB);

  dbms_lob.freetemporary(CCLOB);
  dbms_lob.freetemporary(BBLOB);
end binary_xml;
/
