package com.address;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;


public class ParseExcel {
	private final String[] validExtension = {"xlsx","xls"};
	
	public ParseExcel() {}
	
	public HashSet getExcelData(String absoluteFilePath) {
		HashSet result = new LinkedHashSet();
		File file = new File(absoluteFilePath);
		
		if(!file.exists()) {
			return null;
		}
		
		FileInputStream fis = null;
		String fileName = file.getName();
		String extension = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());
		
		boolean isValid = isValidExtension(extension);

		//System.out.println("fileName = "+fileName);
		//System.out.println("isValid = "+isValid);

		if(!isValid) {
			file.delete();
			return null;
		}
		
		try {
			fis = new FileInputStream(file);
			Workbook workbook= extension.equalsIgnoreCase(validExtension[0]) ? new XSSFWorkbook(fis) : new HSSFWorkbook(fis);
			ArrayList<String> columnNames = new ArrayList<String>();
			
			int rowIndex = 0;
			int columnIndex = 0;
			// ��Ʈ �� (ù��°���� �����ϹǷ� 0�� �ش�)
			// ���� �� ��Ʈ�� �б����ؼ��� FOR���� �ѹ� �� �����ش�.
			Sheet sheet = workbook.getSheetAt(0);
			//���� ��
			int rows = sheet.getPhysicalNumberOfRows();
			for(rowIndex=0;rowIndex<rows;rowIndex++) {
				//���� �д´�.
				Row row = sheet.getRow(rowIndex);
				HashMap<String,String> map = new HashMap<String,String>();
					
				if(row != null) {
					//���� ��
					int cells = row.getPhysicalNumberOfCells();
					String value = "";
					
					for(columnIndex=0;columnIndex<=cells;columnIndex++) {
						//������ �д´�.
						Cell cell = row.getCell(columnIndex);
						//���� ���ϰ�츦 ���� ��üũ
						if(cell == null) {
							//continue;
							value = null;
						} else {
							switch(cell.getCellType()) {
								case Cell.CELL_TYPE_FORMULA:
									value = cell.getCellFormula();
									break;
								case Cell.CELL_TYPE_NUMERIC:
									value = String.valueOf((int)cell.getNumericCellValue());
									break;
								case Cell.CELL_TYPE_STRING:
									value = cell.getStringCellValue();
									break;
								case Cell.CELL_TYPE_BOOLEAN:
									value = String.valueOf(cell.getBooleanCellValue());
									break;
									
								default:
									break;
							}
						}

						if(rowIndex == 0) {
							columnNames.add(value);
						}
						else if(columnNames.size() > 0) {
							String columnName = columnNames.get(columnIndex);
							map.put(columnName, value);
						}
					}
				}
				result.add(map);
			}
			
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if(fis != null) fis.close();
				file.delete();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	private boolean isValidExtension(String extension) {

		if(extension != null) {
			for(String validEx : validExtension) {
				if(extension.equalsIgnoreCase(validEx))
					return true;
			}
				
		}
		return false;
	}
}
