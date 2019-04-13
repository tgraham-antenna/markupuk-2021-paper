SCHEMATRON_DIR=bin/frameworks/xspec/src/schematron/iso-schematron/

echo "Downloading Saxon 9"
if [[ ! -e bin/saxon9.jar ]];
then
  curl -L -q http://central.maven.org/maven2/net/sf/saxon/Saxon-HE/9.9.1-2/Saxon-HE-9.9.1-2.jar > bin/saxon9.jar
fi

rm -rf bin/tmp/
mkdir -p bin/tmp/

echo "Validating with schematron"

java -jar bin/saxon9.jar resources/validation/paper.sch $SCHEMATRON_DIR/iso_dsdl_include.xsl > bin/tmp/paper-includes.sch
java -jar bin/saxon9.jar bin/tmp/paper-includes.sch $SCHEMATRON_DIR/iso_abstract_expand.xsl > bin/tmp/paper-expanded.sch
java -jar bin/saxon9.jar bin/tmp/paper-expanded.sch $SCHEMATRON_DIR/iso_svrl_for_xslt2.xsl > bin/tmp/paper-validate.xsl
java -jar bin/saxon9.jar paper.xml bin/tmp/paper-validate.xsl > bin/tmp/paper.svrl

# Generic rule data: https://docs.sonarqube.org/latest/analysis/generic-issue/
cat <<EOF > bin/tmp/sonar-schematron.json
{ "issues": [
    {
      "engineId": "test",
      "ruleId": "rule1",
      "severity":"BLOCKER",
      "type":"CODE_SMELL",
      "primaryLocation": {
        "message": "First issue",
        "filePath": "paper.xml",
        "textRange": {
          "startLine": 3,
          "endLine": 4,
          "startColumn": 1,
          "endColumn": 2
        }
      },
      "effortMinutes": 90,
      "secondaryLocations": [
        {
          "message": "2ndary location",
          "filePath": "paper.xml",
          "textRange": {
            "startLine": 10,
            "endLine": 10,
            "startColumn": 6,
            "endColumn": 8
          }
        }
      ]
    },
    {
      "engineId": "test",
      "ruleId": "rule2",
      "severity": "INFO",
      "type": "BUG",
      "primaryLocation": {
        "message": "minimal issue raised at file level",
        "filePath": "paper.xml"
      }
    }
]}
EOF