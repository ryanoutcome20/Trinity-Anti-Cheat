mStub = { 
	Files = { }
}

function mStub.Register(File)
	table.insert(mStub.Files, File)
end