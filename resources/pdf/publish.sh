OXY_VERSION="21.0.0.0"

mkdir -p bin
echo "Downloading the DocBook framework"
if [[ ! -e bin/docbook ]];
then
  curl -q https://www.oxygenxml.com/maven/com/oxygenxml/frameworks/21.0.0.0/frameworks-21.0.0.0.zip > bin/frameworks.zip
  unzip -q bin/frameworks.zip -d bin/
fi

echo "Downloading Saxon 6.5.5"
if [[ ! -e bin/saxon.jar ]];
then
  curl -q https://packages.atlassian.com/maven-3rdparty/saxon/saxon/6.5.5/saxon-6.5.5.jar > bin/saxon.jar
fi

echo "Downloading FOP 2.1"
if [[ ! -e bin/fop-2.1 ]];
then
  curl -q http://apache.javapipe.com/xmlgraphics/fop/binaries/fop-2.1-bin.zip > bin/fop.zip
  unzip -q bin/fop.zip -d bin/
fi

mkdir -p out

echo "Generating output"
java -cp "bin/saxon.jar:bin/docbook/xsl/extensions/xslthl.jar" com.icl.saxon.StyleSheet paper.xml bin/docbook/xsl/fo/docbook_custom.xsl > out/paper.fo

export OS=Linux 
bash bin/fop-2.1/fop out/paper.fo out/paper.pdf
rm out/paper.fo
echo "Done"
