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
java -cp "bin/saxon.jar:bin/docbook/xsl/extensions/xslthl.jar" com.icl.saxon.StyleSheet paper.xml bin/docbook/xsl/fo/docbook_custom.xsl \
  admon.graphics=1 \
  admon.graphics.extension=.png \
  admon.graphics.path=bin/docbook/css/img/ \
  "body.font.family=Times New Roman, Arial Unicode MS, Tahoma, Batang, serif" \
  callout.graphics.path=bin/docbook/xsl/images/callouts/ \
  draft.mode="no" \
  fop.extensions=0 \
  fop1.extensions=0 \
  highlight.source=1 \
  highlight.xslthl.config=bin/docbook/xsl/highlighting/xslthl-config.xml \
  "monospace.font.family=monospace, Courier New, Courier, Consolas, Liberation Mono, Arial Unicode MS" \
  paper.type=A4 \
  "title.font.family=Arial, Arial Unicode MS, Tahoma, Batang, sans-serif" > out/paper.fo

export OS=Linux 
bash bin/fop-2.1/fop out/paper.fo out/paper.pdf
rm out/paper.fo
echo "Done"
