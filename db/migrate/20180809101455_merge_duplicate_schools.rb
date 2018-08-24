class MergeDuplicateSchools < ActiveRecord::Migration
  def up
    # TODO: comment out this migration after we run it

    return if School.count == 0 # for Travis

      ActiveRecord::Base.transaction do
      # This school_id_array comes from the spreadsheet at https://jira.nypl.org/browse/MLN-162
      # The format of each school_id_pair is [id_of_school_to_merge, id_of_school_to_keep]
      school_id_array = [[1570, 966], [1571, 1156], [1572, 1159], [1573, 1160], [1574, 1165], [1575, 955], [1576, 1078], [1577, 1172], [1578, 1174], [1579, 1176], [1580, 1184], [1581, 1185], [1582, 1189], [1584, 867], [1502, 1197], [1585, 1203], [1586, 1207], [1587, 1209], [1588, 1211], [1589, 1216], [1590, 1220], [1591, 1224], [1592, 1225], [1648, 1507], [1593, 1226], [1594, 1227], [1595, 1228], [1596, 1229], [1597, 984], [1598, 1230], [1599, 1231], [1602, 1241], [1603, 1246], [1604, 1248], [1600, 1234], [1601, 1237], [1511, 1237], [1606, 1254], [1605, 856], [1607, 1255], [1608, 1256], [1609, 1139], [1651, 1279], [1610, 1279], [1611, 1280], [1652, 1006], [1623, 1282], [1624, 1288], [1657, 1140], [1625, 1140], [1626, 1290], [1627, 1095], [1658, 1095], [1628, 1291], [1629, 1294], [1659, 1124], [1525, 1296], [1661, 846], [1630, 1301], [1631, 1302], [1632, 1303], [1529, 1304], [1668, 1362], [1669, 1365], [1634, 1330], [1670, 763], [1671, 1027], [1635, 1399], [1613, 1536], [1614, 1537], [832, 1532], [1052, 1665], [1616, 1541], [1681, 1435], [1682, 1130], [1683, 1351], [1612, 1553], [1554, 1615], [1691, 803], [1696, 1307], [1697, 1310], [1698, 1094], [1741, 1440], [1636, 1444], [1569, 1422], [1701, 1422], [1637, 1454], [1638, 1455], [1639, 1457], [1702, 1457], [1640, 1458], [1641, 1459], [1561, 1460], [1562, 1461], [1642, 1464], [1703, 1129], [1563, 1470], [1643, 774], [1644, 1474], [1621, 1565], [1680, 1429], [1313, 1647], [1684, 1405], [1685, 1424], [1315, 1662], [1655, 1286], [1723, 1320], [1686, 1434], [1528, 1622], [1690, 1322], [760, 1531], [1656, 782], [1692, 805], [1555, 1619], [1693, 930], [1694, 932], [1512, 1038], [1721, 1454], [1688, 1330]]

      school_id_array.each do |school_id_pair|
        school_to_merge = School.find(school_id_pair[0])
        school_to_keep = School.find(school_id_pair[1])
        puts "IDs: #{[school_to_merge.id, school_to_keep.id]} Campus IDs: #{[school_to_merge.campus_id, school_to_keep.campus_id]}"
        school_to_merge.users.each do |user|
          user.school_id = school_to_keep.id
          user.save
        end
        if school_to_merge.campus_id.present? && school_to_keep.campus_id.blank?
          school_to_keep.campus_id = school_to_merge.campus_id
          school_to_keep.save
        elsif school_to_merge.campus_id.present? && school_to_keep.campus_id.present? && school_to_merge.campus_id != school_to_keep.campus_id
          raise 'prevented overwriting of school_to_keep.campus_id'
        end
        school_to_merge.destroy
      end

      # downcase all zcodes and change 'zz' to 'z'
      School.all.each do |school|
        school.code = school.code.downcase.gsub('zz', 'z')
        school.save
      end
    end
  end
  def down
    raise 'Cannot rollback this migration'
  end
end
