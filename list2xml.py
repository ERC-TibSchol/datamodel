import csv
import argparse
from textwrap import indent
from xml.etree import ElementTree as ET

FLAGSEP=","

parser = argparse.ArgumentParser()
parser.add_argument("-i",help = "Input file (csv)", action="store", dest="i")
parser.add_argument("-t",help = "Template document (XML)", action="store", dest="t" )
parser.add_argument("-o",help = "Output file (XML)", action="store", dest="o")

args=parser.parse_args()

#outputDoc = ET.ElementTree(element="_")


template = open(args.t, mode="r")
templateDoc = template.read()

with open(args.i) as csvfile:
    relReader = csv.DictReader(csvfile)
    with open(args.o, mode="w") as output:
        output.write("<relations>")
        for row in relReader:
            scA = row["sourceClassArity"]
            tcA = row["targetClassArity"]
            dN = row["directName"]
            rN = row["reverseName"]
            flags = row["flags"]
            data = templateDoc.format(
                SOURCECLASS_ARITY=scA,
                TARGETCLASS_ARITY=tcA,
                DIRECTNAME=dN,
                DIRECTNAME_LC=dN.lower(),
                DIRECTNAME_UC=dN.upper(),
                DIRECTNAME_NB=dN.replace(' ',''),
                REVERSENAME=dN,
                REVERSENAME_LC=dN.lower(),
                REVERSENAME_UC=dN.upper(),
                REVERSENAME_NB=dN.replace(' ','')
            )
            x = ET.fromstring(data)
            
            for includeParent in x.findall(".//INCLUDE/.."):
                for include in includeParent.findall("INCLUDE"):
                    if include.get("FLAG") in flags.split(' '):
                        print(include.get("FLAG"))
                        print(flags.split(' '))
                        includeParent.remove(include)
                        includeParent.append(include.find("./*"))
                    else:
                        includeParent.remove(include)

            
            output.write(ET.tostring(x, encoding="unicode", method="xml"))
        output.write("</relations>")
        output.close()
    """ with open(args.o, mode="r") as output:
        templateXML=ET.parse(output)
        templateXML. """