import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.table.*;
import java.io.*;
import com.mathworks.jmi.*; //The Java MATLAB Interface package ...

/**
 * A class which objects create a GUI for displaying datasets in a 
 * datafile.
 *  
 * @author 
 * 	<a href="mailto:bram.vandesande@student.kuleuven.ac.be">Bram Van de Sande</a>
 */
public class ExampleGUIJava {
	/****************************************************************
	 * 							Constuctor							*
	 ****************************************************************/
	
	/**
	 * Create a new GUI for viewing datasets in datafiles.
	 * 
	 * @param x
	 * 		The number pixels that the upper right corner of the GUI dialog is
	 * 		deviated from the upper right corner of the screen in the horizontal
	 * 		direction.
	 * @param y
	 * 		The number pixels that the upper right corner of the GUI dialog is
	 * 		deviated from the upper right corner of the screen in the vertical
	 * 		direction.
	 * @param width
	 * 		The width of the GUI dialog in pixels.
	 * @param height
	 * 		The height of the GUI dialog in pixels.
	 * @param dataDir
	 * 		The data directory where the datafiles are located.
	 */
	public ExampleGUIJava(int x, int y, int width, int height, String dataDir)
	{
		//Set the data directory for this GUI ...
		try { setDataDirectory(dataDir); }
		catch (IllegalArgumentException exc) {
			JOptionPane.showMessageDialog(new JFrame(), 
					"'" + dataDir + "' is not a valid directory or does not exist.", 
					"ExampleGUI", JOptionPane.INFORMATION_MESSAGE);
			return;
		}
		
		//Initialize toolbar ...
		setupToolBar();
		
		//Initialize spreadsheet ...
		setupSpreadSheet();
		
		//Initialize frame ...
		setupFrame(x, y, width, height);
	}	
	
	/****************************************************************
	 * 						Public Interface						*
	 ****************************************************************/
	
	/**
	 * Returns the directory where the GUI looks for datafiles.
	 */
	public String getDataDirectory() { return $dataDir;	}
	
	/**
	 * Sets the directory where the GUI looks for datafiles.
	 *  
	 * @param directory
	 * 		The new data directory.
	 * @throws IllegalArgumentException
	 * 		When the supplied data directory is not valid or does
	 * 		not exist. 
	 */
	public void setDataDirectory(String directory) 
		throws IllegalArgumentException {
		File dir = new File(directory);
		if (!dir.isDirectory()) throw new IllegalArgumentException();
		if (directory.endsWith(File.separator)) $dataDir = directory;
		else $dataDir = directory + File.separator;
	}
	
	/**
	 * Get list of datafiles in current data directory. A list of names of
	 * datafiles is returned without extension.
	 */
	private String[] getDirectoryList() {
		File dir = new File(getDataDirectory());
		String[] fileNames = dir.list(
				new FilenameFilter() {
					public boolean accept(File file, String fileName) {	
						return fileName.endsWith(getDataFileExtension()); 
					}
				});
		for (int i = 0; i < fileNames.length; i++)
			fileNames[i] = fileNames[i].substring(0, fileNames[i].indexOf('.'));
		return fileNames;
	}
	
	/**
	 * The data directory is stored as a reference to a String object.
	 */
	private String $dataDir;
	
	/**
	 * Returns the extension used for recognizing datafiles. 
	 */
	public String getDataFileExtension() { return ".log"; }
	
	/**
	 * Returns the name of the datafile currently selected in the GUI.
	 */
	public String getCurrentFileName() { return $fileName; }
	
	/**
	 * Sets the current selected datafile.
	 * 
	 * @param fileName
	 * 		The name of the datafile selected.
	 */
	public void setCurrentFileName(String fileName) { $fileName = fileName; }
	
	/**
	 * The name of the datafile selected is stored as a reference to a
	 * String object.
	 */
	private String $fileName;
	
	/**
	 * Returns the path and name of the datafile currently selected in
	 * the GUI.
	 */
	public String getCurrentFullFileName() {
		return getDataDirectory() + getCurrentFileName();
	}
	
	/**
	 * Returns the sequence number of the dataset currently selected in
	 * the GUI.
	 */
	public int getCurrentSeqNr() { return $sequenceNumber; }
	
	/**
	 * Sets the sequence number of the current selected dataset.
	 * 
	 * @param seqNumber
	 * 		The sequence number of the dataset selected.
	 */
	private void setCurrentSeqNr(int seqNumber) { $sequenceNumber = seqNumber; }
	
	/**
	 * The sequence number of the selected datafile is stored as an
	 * integer.
	 */
	private int $sequenceNumber;
	
	/**
	 * Returns the identifier of the dataset currently selected in
	 * the GUI.
	 */
	public String getCurrentSeqID() { return $sequenceID; }
	
	/**
	 * Sets the sequence identifier of the current selected dataset.
	 * 
	 * @param seqID
	 * 		The sequence identifier of the dataset selected.
	 */
	private void setCurrentSeqID(String seqID) { $sequenceID = seqID; }
	
	/**
	 * The sequence identifier of the selected datafile is stored as a
	 * reference to a String object.
	 */
	private String $sequenceID;
	
	/**
	 * Reset the spreadsheet with new data and set the first row as the
	 * selected row.
	 * 
	 * @param seqNrs
	 * 		An array of sequence numbers.
	 * @param seqIDs
	 * 		An array of sequence identifiers.
	 */
	public void setSpreadSheetData(Object[] seqNrs, Object[] seqIDs) {
		int length = seqNrs.length;
		$spreadSheetData = new Object[2][length];
		for (int i = 0; i < length; i++) {
			setSpreadSheetData(seqNrs[i], i, 0);
			setSpreadSheetData(seqIDs[i], i, 1);
		}
		try {
			getSpreadSheet().getSelectionModel().setSelectionInterval(0, 0);
			getSpreadSheet().updateUI();
		}
		catch (NullPointerException exc) {}
	}
	
	/**
	 * Set the cell with given row number and column number in the spreadsheet
	 * to the specified value.
	 * 
	 * @param value
	 * 		The new value for the specified cell.
	 * @param rowNr
	 * 		The row number of the cell.
	 * @param colNr
	 * 		The column number of the cell.
	 */
	private void setSpreadSheetData(Object value, int rowNr, int colNr) {
		$spreadSheetData[colNr][rowNr] = value;
	}
	
	/**
	 * Get the value of the cell with given row number and column number in the
	 * spreadsheet.
	 * 
	 * @param rowNr
	 * 		The row number of the cell.
	 * @param colNr
	 * 		The column number of the cell.
	 */
	public Object getSpreadSheetData(int rowNr, int colNr) {
		return $spreadSheetData[colNr][rowNr];
	}	
	
	/**
	 * Return the number of columns in the spreadsheet. 
	 */
	public int getNrOfColumnsInSpreadSheet() {
		if ($spreadSheetData == null) return 0;
		else return 2;
	}
	
	/**
	 * Return the number of rows in the spreadsheet. 
	 */
	public int getNrOfRowsInSpreadSheet() {
		if ($spreadSheetData == null) return 0;
		else return $spreadSheetData[0].length;
	}
	
	/**
	 * Reset the spreadsheet and make it empty.
	 */
	public void clearSpreadSheetData() {
		$spreadSheetData = null;
		getSpreadSheet().getSelectionModel().clearSelection();
		setCurrentFileName(null);
		setCurrentSeqID(null);
		setCurrentSeqNr(0);
	}
	
	/**
	 * The data for the spreadSheet is stored in a 2 by N array of
	 * references to Objects.
	 */
	private Object[][] $spreadSheetData;
	
	/****************************************************************
	 * 						Local methods							*
	 ****************************************************************/
	
	/**
	 * Setup the toolbar for the GUI. 
	 */
	private void setupToolBar() { 
		$toolBar = new JToolBar();
		addExitButton();
		addOpenButton();
		addSelectionButton();
		addCallBackButton(" Thr ", "ExampleGUI('thr');");
		addCallBackButton(" Rate ", "ExampleGUI('rate');");
		addCallBackButton(" PST ", "ExampleGUI('pst')");
		addCallBackButton(" PRD ", "ExampleGUI('prd')");
		addCallBackButton(" ISI ", "ExampleGUI('isi')");
		addCallBackButton(" VS/PH ", "ExampleGUI('vsph')");
	}
	private void addExitButton() {
		JButton button = new JButton(" Exit ");
		button.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent event) { getFrame().dispose(); }
		});
		getToolBar().add(button);
	}
	private void addOpenButton() {
		JButton button = new JButton(" Open ");
		button.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				JFileChooser dialog = new JFileChooser();
				dialog.setCurrentDirectory(new File(getDataDirectory()));
				dialog.setDialogTitle("ExampleGUI: Select new data directory ...");
				dialog.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				if (dialog.showOpenDialog(getFrame()) == JFileChooser.APPROVE_OPTION) 
				{
					String newDirectory = dialog.getSelectedFile().getAbsolutePath();
					try { setDataDirectory(newDirectory); }
					catch(IllegalArgumentException exc) {
						JOptionPane.showMessageDialog(new JFrame(), 
								"'" + newDirectory + "' is not a valid directory or does not exist.", 
								"ExampleGUI", JOptionPane.INFORMATION_MESSAGE);
					}
					setSelectionBoxList(getDirectoryList());
				}				
			}
		});
		getToolBar().add(button);
	}
	private void addSelectionButton() {
		setSelectionBox(new JComboBox());
		setSelectionBoxList(getDirectoryList());
		getSelectionBox().addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				setCurrentFileName((String)getSelectionBox().getSelectedItem());
				try { (new Matlab()).evalConsoleOutput("ExampleGUI('load')"); }
				catch (Exception exc) {	System.err.println(exc.getMessage()); }
			}
		});
		getToolBar().add(getSelectionBox());
	}
	private void addCallBackButton(String name, final String matlabCallBack) {
		JButton button = new JButton(name);
		button.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				try { (new Matlab()).evalConsoleOutput(matlabCallBack); }
				catch (Exception exc) { System.err.println(exc.getMessage()); }
			}
		});
		getToolBar().add(button);
	}
	
	/**
	 * Returns a reference to the toolbar.
	 */
	private JToolBar getToolBar() { return $toolBar; }
	
	/**
	 * The toolbar is stored as a reference to a JToolBar object.
	 */
	private JToolBar $toolBar;

	/**
	 * Returns a reference to the selection box.
	 */
	private JComboBox getSelectionBox() { return $selectionBox; }
	
	/**
	 * Sets the selection box.
	 */
	private void setSelectionBox(JComboBox selBox) { $selectionBox = selBox; }
	
	/**
	 * Add a new list of items to the selection box and sets the selected item
	 * to the first element in the list.
	 * 
	 * @param list
	 * 		The new list of items.
	 */
	private void setSelectionBoxList(String[] list) {
		getSelectionBox().removeAllItems();
		for (int i = 0; i < list.length; i++) getSelectionBox().addItem(list[i]);
		if (getSelectionBox().getItemCount() > 0) {
			getSelectionBox().setSelectedItem(list[0]);
			setCurrentFileName(list[0]);
			try { (new Matlab()).evalConsoleOutput("ExampleGUI('load')"); }
			catch (Exception exc) {	System.err.println(exc.getMessage()); }
		}
		else clearSpreadSheetData();
	}
	
	/**
	 * The selection box is stored as a reference to a JComboBox object.
	 */
	private JComboBox $selectionBox;
	
	/**
	 * Return the spreadsheet. 
	 */
	private JTable getSpreadSheet() { return $spreadSheet; }
	
	/**
	 * Setup the spreadsheet.
	 */
	private void setupSpreadSheet() {
		$spreadSheet = new JTable();
		getSpreadSheet().setModel( new AbstractTableModel() {
			private String[] columnNames = {"SeqNr", "SeqID"}; 
		    public String getColumnName(int col) { return columnNames[col]; }
		    
		    public int getRowCount() { return getNrOfRowsInSpreadSheet(); }
		    public int getColumnCount() { return columnNames.length; }
		    
		    public boolean isCellEditable(int row, int col) { return false; }
		    
		    public Object getValueAt(int row, int col) {
		    	return getSpreadSheetData(row, col);
		    }
		    public void setValueAt(Object value, int row, int col) {
		    	setSpreadSheetData(value, row, col);
		        fireTableCellUpdated(row, col);
		    }
		});
		getSpreadSheet().setShowHorizontalLines(false);
		getSpreadSheet().setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		getSpreadSheet().getSelectionModel().addListSelectionListener(new ListSelectionListener() {
			public void valueChanged(ListSelectionEvent event) {
				if (getNrOfRowsInSpreadSheet() > 0) {
					setCurrentSeqNr(((Double)getSpreadSheetData(getSpreadSheet().getSelectedRow(), 0)).intValue());
					setCurrentSeqID((String)getSpreadSheetData(getSpreadSheet().getSelectedRow(), 1));
				}
				else {
					setCurrentSeqNr(0);
					setCurrentSeqID(null);
					getSpreadSheet().updateUI();
				}
			}
		});
		getSpreadSheet().addMouseListener( new MouseAdapter() {
			public void mouseClicked(MouseEvent event) {
				if (event.getClickCount() == 2)
					try { (new Matlab()).evalConsoleOutput("ExampleGUI('show')"); }
					catch (Exception exc) {	System.err.println(exc.getMessage()); }
			}
		});
		getSpreadSheet().getTableHeader().addMouseListener( new MouseAdapter() {
			public void mouseClicked(MouseEvent event) {
					if (event.getClickCount() == 1) {
						int colNr = ((JTableHeader)event.getSource()).columnAtPoint(event.getPoint());
						Object[] inputArgs = {"sort", new Double(colNr), $spreadSheetData[0], $spreadSheetData[1]};
						try { (new Matlab()).fevalConsoleOutput("ExampleGUI", inputArgs, 0, null); }
						catch (Exception exc) {	System.err.println(exc.getMessage()); }
					}
				}
			});
	}
	
	/**
	 * The spreadsheet is stored as a reference to a JTable object.
	 */
	private JTable $spreadSheet;
	
	/**
	 * Create a GUI dialog.
	 * 
	 * @param x
	 * 		The number pixels that the upper right corner of the GUI dialog is
	 * 		deviated from the upper right corner of the screen in the horizontal
	 * 		direction.
	 * @param y
	 * 		The number pixels that the upper right corner of the GUI dialog is
	 * 		deviated from the upper right corner of the screen in the vertical
	 * 		direction.
	 * @param width
	 * 		The width of the GUI dialog in pixels.
	 * @param height
	 * 		The height of the GUI dialog in pixels.
	 */
	private void setupFrame(int x, int y, int width, int height) { 
		$frame = new JFrame("ExampleGUI (" + getDataDirectory() + ")");
		getFrame().addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent event) { event.getWindow().dispose();	}
		});
		getFrame().setLocation(x, y);
		getFrame().setSize(width, height);
		getFrame().getContentPane().setLayout( new BorderLayout() );
		getFrame().getContentPane().add(getToolBar(),BorderLayout.NORTH);
		getFrame().getContentPane().add(new JScrollPane(getSpreadSheet()),BorderLayout.CENTER);
		getFrame().show();
	}
	
	/**
	 * Return the GUI frame.
	 */
	public JFrame getFrame() { return $frame; }
	
	/**
	 * The GUI frame is stored as a reference to a JFrame object.
	 */
	private JFrame $frame;
}
