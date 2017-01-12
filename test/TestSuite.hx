import massive.munit.TestSuite;

import com.thomasuster.ws.ByteStringerTest;
import com.thomasuster.ws.FrameReaderTest;
import com.thomasuster.ws.FrameWriterTest;
import com.thomasuster.ws.HandShakerTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(com.thomasuster.ws.ByteStringerTest);
		add(com.thomasuster.ws.FrameReaderTest);
		add(com.thomasuster.ws.FrameWriterTest);
		add(com.thomasuster.ws.HandShakerTest);
	}
}
