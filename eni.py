#!/usr/bin/python       
# *-* coding: utf-8 *-*

"""# *-* coding: iso-8859-1 *-*"""
import re
import sys
import os
import socket
import urllib
import time
import gzip
from cStringIO import StringIO
from bs4 import BeautifulSoup

""" 
exec https://raw.github.com/pypa/pip/master/contrib/get-pip.py
pip install beautifulsoup4
"""


debug=False
id_cookie=""
id_session=""
host_str="www.eni-training.com"
user_agent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0"
accept_str="text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01"
accept_lang_str="fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3"
accept_enc_str="gzip, deflate"
dnt_str="1"
content_type="application/x-www-form-urlencoded; charset=UTF-8"
x_req="XMLHttpRequest"
referer="http://www.eni-training.com/client_net/bntopic.aspx?idsession="+id_session+"&idtopic=2"
content_len="22"
cookie="MplusUserSettings=Lng=1; ENI_Editions_Portail=Identifiant="+id_cookie+"; __atuvc=28%7C7"
conn="keep-alive"
pragma="no-cache"
cache_ctrl="no-cache"
param="SpentTimeRefresh"

refresh_str="POST /client_net/manageSession.aspx?idsession="+id_session+" HTTP/1.1\r\nHost: "+host_str+"\r\nUser-Agent: "+user_agent+"\r\nAccept: "+accept_str+"\r\nAccept-Language: "+accept_lang_str+"\r\nAccept-Encoding: "+accept_enc_str+"\r\nDNT: "+dnt_str+"\r\nContent-Type: "+content_type+"\r\nX-Requested-With: "+x_req+"\r\nReferer: "+referer+"\r\nContent-Length: "+content_len+"\r\nCookie: "+cookie+"\r\nConnection: "+conn+"\r\nPragma: "+pragma+"\r\nCache-Control: "+cache_ctrl+"\r\n\r\nparam=SpentTimeRefresh"





class Section:
    def __init__(self,title,url):
        self.titre=title
        self.url=url
        self.strz=""
        #self.extract_content()
        
    def extract_content(self):
        html = self.url      
        soup = BeautifulSoup(html)
        #content = soup.find("div", {"class" : "MEDIABook_CallBack_PrgContent_Container"})
        content = soup.find("div", {"id" : "Content"})
        if content is not None:
            print content.string
            self.strz=content.string
        
    def printz(self):
        print "\n\t\tSection ", self.titre
        print "\n\t\thref", self.url
        
    def set_titre(self,strz):
        self.titre = strz
        
    def set_url(self,url):
        self.url = url
        
    def get_titre(self):
        print "\n\t\tSection ", self.titre
        return self.titre
        
    def get_url(self):
        print "\n\t\thref ", self.url
        return self.url


class Chap:
    def __init__(self,title):
        self.titre=title
        self.list_sections=[]
        
    def printz(self):
        print "\n\tChapitre",self.titre
        for section in self.list_sections :
            if isinstance(section, Section):
                section.printz()
                #print "\n\t\tSection ",section.titre
                #print "\n\t\thref" section.url
                
    def add_sec(self,section):
        if isinstance(section, Section):
            self.list_sections.append(section)
            
    def set_titre(self,strz):
        self.titre = strz
        
    def get_titre(self):
        print "\n\t\tSection ", self.titre
        return self.titre
        
    def get_sections(self):
        self.printz()
        return self.list_sections

class Docu:      
    def __init__(self,idz,title):
        self.id=idz
        self.titre=title
        self.list_chapter=[]

    def printz(self):
        print "id = ", self.id
        print "titre = ", self.titre
        for chap in self.list_chapter:
            chap.printz()

    def add_chap(self,chapz):
        if isinstance(chapz, Chap):
            self.list_chapter.append(chapz)
            
    def get_chapters(self):
        self.printz()
        return self.list_chapter
  
def read_file():
    f = open('test.html', 'r')
    str = f.read()
    f.close()
    #print "Fichier =", str
    return str

def next_markup(balise,strz):
    markup_start = "<"+balise+".*>"
    markup_end = "</"+balise+">"
    patern = markup_start+"(.*)"+markup_end
    if isinstance(strz,str):
        m = re.search(patern, strz)
        if m is not None:
            if m.group(1) is not None:
                val = m.group(1)
                print "next", balise,"=>", val
                return val
    
def disec_lpanel(str):
    """
    <div id="left_Panel" 
    <div class="ScrollContent">
    <div id="Summary">
    <ul id="Root">
    <li><h2>
    """
    tmp = str.rsplit("<div id=\"left_Panel")[1]
    ret = tmp.rsplit("<div id=\"SearchResults\">")[0]
    tmp= ret.rsplit("<div id=\"Summary\">")[1]
    ret = tmp.rsplit(" </div>")[0]
    return ret

def print_arr(arr):
    print ""
    for elem in arr:
        print "elem",elem

def get_title(html):
    soup = BeautifulSoup(html)
    title = soup.find("div", {"id" : "Menu"}).strong.string
    print "title",title
    return title


def summary2doc(html,idz):

    soup = BeautifulSoup(html)
    #print soup.prettify()
    
    #ul_root = soup("div", {"class" : "Summary"})
    ul_root = soup.find("ul", {"id" : "Root"})
    
    title = get_title(html)    
    docu = Docu(str(idz),str(title))

    for sibling in ul_root.li.next_siblings:
        #print (sibling.name)
        if sibling.name == "li":
            var = sibling.li.find('a')
            if debug is True:
                print "\n\tChapitre ", sibling.h2.string
                print "\t\tSection ", var.string
                print "\t\thref =" ,var['href']
            chap = Chap(sibling.h2.string)
            chap.add_sec( Section( var.string, var['href'] ) )
            for section in sibling.li.next_siblings:
                #print section.name
                if section.name == "li":
                    tmp = section.find('a')
                    if tmp is not -1:                    
                        if debug is True:
                            print "\t\tSection ",tmp.string 
                            print "\t\thref =" ,tmp['href']
                        chap.add_sec( Section( tmp.string, tmp['href'] ) )
            docu.add_chap(chap)
    docu.printz()
    return docu

def extract_data(html):
    soup = BeautifulSoup(html)
    #content = soup.find("div", {"class" : "MEDIABook_CallBack_PrgContent_Container"})
    content = soup.find("div", {"id" : "Content"})
    if content is not None:
        strz=content.string
    return strz

def sr1(sock,strz):
    try:
        sock.send(strz)
        data = ""
        part = None
        while part != "":
            try:
                part = sock.recv(4096)
                data+=part
            except socket.timeout:
                print "socket 1sec timeout"
                print "receive data length",len(data)
                return data
        
        print "receive data length",len(data)
        return data
        
    except Exception:
          return data
       
    

def get_id_cookie(strz):
     m = re.search('Set-Cookie: ENI_Editions_Portail=Identifiant=(.*); ', strz)
     if m is None:
          print "Warning :  id_cookie not found"
          sys.exit(0)
     else:
          id_cookie = m.group(1)
          print 'id_cookie =', id_cookie
          return id_cookie

def get_id_session(strz):
     gziped = strz.rsplit("Accept-Encoding\r\n\r\n")[1]
     if gziped is not None:
         #print "gziped",gziped
         tmp = gzip.GzipFile('', 'r', 0, StringIO(gziped))
         data = tmp.read()
         print "gunzip str =", data
         m = re.search('idsession=(.*)\'', data)
         #print dir(m)
         id_session=m.group(1)
         print "id_session=",id_session  
         m2 = re.search('goTo.\'(.*)\'', data)
         next_url=m2.group(1)
         print "next_url=", next_url
         return id_session, next_url    

def request_str(url):
     req = "GET /"+url+" HTTP/1.1\r\n"
     req+= "Host: www.eni-training.com\r\n"
     req+= "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0\r\n"
     req+= "Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01\r\n"
     req+= "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3\r\n"
     req+= "Accept-Encoding: gzip, deflate\r\n"
     req+= "Content-Type: application/x-www-form-urlencoded; charset=UTF-8\r\n"
     req+= "Cookie: MplusUserSettings=Lng=1; ENI_Editions_Portail=Identifiant="+id_cookie+"; __atuvc="+atuvc+"\r\n"
     req+= "Connection: keep-alive\r\n"
     req+= "Cache-Control: no-cache\r\n\r\n"
     return req

def request_img(img_url):
    #img_url="/client_net/styles/default/images/chip_summary_opened.png"
    img_accept_str="image/png,image/*;q=0.8,*/*;q=0.5"
    req_img="GET "+img_url+" HTTP/1.1\r\n"
    "Host: "+host_str+"\r\n"
    "User-Agent: "+user_agent+"\r\n"
    "Accept: "+img_accept_str+"\r\n"
    "Accept-Language: "+accept_lang_str+"\r\n"
    "Accept-Encoding: "+accept_enc_str+"\r\n"
    "DNT: "+dnt_str+"\r\n"
    "Referer: "+referer+"\r\n"
    "Cookie: "+cookie+"\r\n"
    "Connection: "+conn+"\r\n\r\n"
  
def request_doc_id(id):
     req_book_id="GET /client_net/mediabook.aspx?idsession="+id_session+"&idr="+id_book+" HTTP/1.1\r\n"
     req_book_id+="Host: "+host_str+"\r\n"
     req_book_id+="User-Agent: "+user_agent+"\r\n"
     req_book_id+="Accept: "+req_accept_str+"\r\n"
     req_book_id+="Accept-Language: "+accept_lang_str+"\r\n"
     req_book_id+="Accept-Encoding: "+accept_enc_str+"\r\n"
     req_book_id+="DNT: "+dnt_str+"\r\n"
     req_book_id+="Referer: "+referer+"\r\n"
     req_book_id+="Cookie: "+cookie+"\r\n"
     req_book_id+="Connection: "+conn+"\r\n"
     return req_book_id

def str_first_contact():
    rqt ="GET /client_net/login.aspx?cfgbdd=LIVRES_GRATUITS HTTP/1.1\r\n"
    rqt +="Host:"+ host_str +"\r\n"
    rqt +="User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0\r\n"
    rqt +="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n"
    rqt +="Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3\r\n"
    rqt +="Accept-Encoding: gzip, deflate\r\n"
    rqt +="DNT: 1\r\n"
    rqt +="Connection: keep-alive\r\n\r\n"
    return rqt



def log_eni(login, pcw):
    body = "user_login="+login+"&user_pwd="+pcw+"&idlng=1"
    req = "POST /client_net/connect.aspx?cfgsite=Default&cfgbdd=LIVRES_GRATUITS HTTP/1.1\r\n"
    req+= "Host: www.eni-training.com\r\n"
    req+= "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0\r\n"
    req+= "Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01\r\n"
    req+= "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3\r\n"
    req+= "Accept-Encoding: gzip, deflate\r\n"
    #req+= "Accept-Encoding: identity\r\n"
    req+= "DNT: 1\r\n"
    req+= "Content-Type: application/x-www-form-urlencoded; charset=UTF-8\r\n"
    req+= "X-Requested-With: XMLHttpRequest\r\n"
    req+= "Referer: http://www.eni-training.com/client_net/login.aspx?cfgsite=Default&cfgbdd=LIVRES_GRATUITS\r\n"
    req+= "Content-Length: "+str(len(body))+"\r\n"
    #req+= "Cookie: MplusUserSettings=Lng=1; ENI_Editions_Portail=Identifiant="+id_cookie+"; __atuvc="+atuvc+"\r\n"
    req+= "Connection: keep-alive\r\n"
    req+= "Pragma: no-cache\r\n"
    req+= "Cache-Control: no-cache\r\n\r\n"
    req+= body
    return req


def check_http_ans(strz):
    if strz is not None:
        if "HTTP/1.1 200 OK" in strz:
            print "200 answer OK"
            return True
        elif "HTTP/1.1 400 Bad Request" in strz:
            print "400 Bad Request"
            return False
        else:
            print "chunked packet or others HTTP errors"
            return False
    print "socket No answer"        
    return False

if __name__ == "__main__":

    
    host_str="www.eni-training.com"
    login=urllib.quote("peon@dusud.com")    # field to fill
    pcw=urllib.quote("PASSWORD")            #    "    "
    id_book = "63754"                       #   "      "  
    
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.settimeout(0.5)
    s.connect((host_str,80))
    
    
    tmp = sr1(s,str_first_contact())
    if check_http_ans(tmp):
        dataz = sr1(s,log_eni(login, pcw))
        if check_http_ans(dataz):
            id_cookie = get_id_cookie(dataz)
            id_session, nxt_url = get_id_session(dataz)
            dataz  = sr1(s,request_str(nxt_url))
            if check_http_ans(dataz):
                html  = sr1(s,request_doc_id(id_book)) #from web
                #html = read_file() #from file
    
                docu = summary2doc(html,id_book)    
                extract_data(html)
                #todo  (test extracted data, site offline)
                #todo   look title chapter/section in extracted data
                #todo   (data extract append to a file)
                #todo   (transform data to latex lang, example elem between h2 -> /section
                #todo   download img form href in extracted data to imd folder and rename 
                #todo   parse entry arg
    
    s.close()
    

    
    
    
