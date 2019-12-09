artifacts builderVersion: "1.1", {

  group "com.sap.bds.ats-altiscale", {

    artifact "sqoop", {
      file "${gendir}/src/sqooprpmbuild/sqoop-artifact/alti-sqoop-${buildVersion}.rpm"
    }
  }
}