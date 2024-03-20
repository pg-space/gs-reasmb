import sys
import glob
import xml.etree.ElementTree as ET

for xml in glob.glob(f"{sys.argv[1]}/*.xml"):
    prj_idx = xml.split("/")[-1][:-4]
    tree = ET.parse(xml)
    root = tree.getroot()
    i = 1
    for e in root:
        if e.tag == "DocumentSummary":
            seqt, layout, sra_idx = "", "", ""
            for e in e:
                if e.tag == "ExpXml":
                    for e in e:
                        if e.tag == "Instrument":
                            seqt = list(e.attrib.values())[0]
                        elif e.tag == "Library_descriptor":
                            for e in e:
                                if e.tag == "LIBRARY_LAYOUT":
                                    layout = e[0].tag
                elif e.tag == "Runs":
                    try:
                        sra_idx = e[0].attrib["acc"]
                    except IndexError:
                        sra_idx = "XXX"
            print(prj_idx, i, sra_idx, seqt, layout, sep=",")
            i+=1
