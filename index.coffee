match = (a, b) -> (a.high is b.high) and (a.low is b.low)

module.exports = class Recall
	constructor: (dispatch) ->
		party = {}
		id =
			high: 0
			low: 0

		dispatch.hook 'sSelfInfo', (data) ->
			id = data.cid
			return

		dispatch.hook 'sAbsorbDamage', (data) ->
			if !match data.target, id
				dispatch.toClient 'sAttackResult',
					source: id
					target: data.target
					model: 10101
					skill: 10100 + 0x4000000
					stage: 0
					unk1: 0
					id: 0
					time: 0
					damage: data.damage
					type: 1
					type2: 4
					crit: 0
					unk2: 0
					unk3: 0
					unk4: 0
					unk5: 0
					unk6: 0
					unk7: 0
					unk8: 0
					unk9: 0
					unk10: 0
					unk11: []
			return

		dispatch.hook 'sPartyList', (data) ->
			party = {}
			for member in data.members
				party[member.cID.high] ?= {}
				party[member.cID.high][member.cID.low] = 1
			return

		dispatch.hook 'sAttackResult', (data) ->
			if party[data.source.high]?[data.source.low]?
				if data.type is 1
					noct = +match data.source, id
					data.source = id
					data.type2 = (data.type2 & ~4) | (noct << 2)
			true
