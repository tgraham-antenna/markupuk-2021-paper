SOURCE=paper.xml

mkdir -p bin
if [[ ! -e bin/oxygen-pdf-chemistry ]];
then
  wget https://www.oxygenxml.com/InstData/Chemistry/oxygen-pdf-chemistry.zip -O bin/oxygen-pdf-chemistry.zip
  unzip bin/oxygen-pdf-chemistry.zip -d bin/
fi

if [[ ! -e bin/frameworks ]];
then
  wget https://www.oxygenxml.com/maven/com/oxygenxml/frameworks/21.0.0.0/frameworks-21.0.0.0.zip -O bin/frameworks.zip
  mkdir bin/frameworks
  unzip bin/frameworks.zip -d bin/frameworks/
fi

mkdir -p out

sh "bin/oxygen-pdf-chemistry/chemistry.sh" -in "${SOURCE}" \
  -css resources/pdf/paper.less bin/frameworks/docbook/css/docbook.css bin/frameworks/docbook/css/print.css \
  -out "out/paper.pdf"


