import cx_Oracle

conn = cx_Oracle.connect(user='system', password='oracle', dsn='localhost/orcl')

callproc = conn.cursor()
'''callproc.execute("begin binary_xml;  commit; end;")'''
callproc.execute("begin report_album;  commit; end;")

curb = conn.cursor()
curb.execute("select BDATA from file_buf")
b = curb.fetchone()

with open('binaryXML.xml', 'wb',) as f:
    f.write(b[0].read())

conn.close()
