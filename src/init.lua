--!optimize 2
--!strict

--[=[
	A utility library for locking things.
	@class Locker
]=]
local Locker = {}

--[=[
	Locks an object. Only works on tables, obviously.

	Alias for `table.freeze`.

	@function Lock
	@param object T -- The object to lock.
	@return T -- The locked object.
	@within Locker
]=]

Locker.Lock = table.freeze

--[=[
	Checks if an object is locked. Only works on tables, obviously.

	Alias for `table.isfrozen`.

	@function IsLocked
	@param object T -- The object to check the status of.
	@return boolean -- Whether or not the table is locked.
	@within Locker
]=]
Locker.IsLocked = table.isfrozen

--[=[
	Does a deep lock on an object. Only works on tables, obviously.
	@param object T -- The object to lock.
	@return T -- The locked object.
	@within Locker
]=]
local function DeepLock(object: {[any]: any})
	assert(type(object) == "table", `invalid argument #1 to 'Locker.DeepLock' (expected table, got {type(object)})`)
	local new = table.clone(object)
	for key, value in new do
		if type(value) == "table" then
			new[key] = DeepLock(value)
		end
	end

	return if not table.isfrozen(new) then table.freeze(new) else new
end

--[=[
	Does a safe lock on an object (only locks if it's not already locked). Only works on tables, obviously.
	@param object T -- The object to lock.
	@return T -- The locked object.
	@within Locker
]=]
local function SafeLock(object: {[any]: any})
	if not table.isfrozen(object) then
		table.freeze(object)
	end

	return object
end

Locker.DeepLock = DeepLock :: typeof(table.freeze)
Locker.SafeLock = SafeLock :: typeof(table.freeze)

table.freeze(Locker)
return Locker
